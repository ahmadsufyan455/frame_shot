import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:image/image.dart' as img;

import '../models/exif_data.dart';
import '../models/export_settings.dart';
import '../models/frame_config.dart';
import '../models/frame_style.dart';
import 'frame_painter_factory.dart';
import 'watermark_painter.dart';

abstract final class ExportRenderer {
  static Future<Uint8List> render({
    required String sourceImagePath,
    required ExifData exif,
    required FrameConfig config,
    required FrameStyleId styleId,
    required ExportSettings settings,
    required bool isPro,
  }) async {
    // 1. Decode source at full or capped resolution.
    final bytes =
        await File(sourceImagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: isPro
          ? null
          : ExportSettings.freeMaxDimension,
    );
    final frame = await codec.getNextFrame();
    final fullImage = frame.image;

    // 2. Load watermark for free tier.
    final ui.Image? watermark =
        isPro ? null : await WatermarkLoader.load();

    // 3. Create painter at full resolution.
    final painter = FramePainterFactory.create(
      styleId: styleId,
      image: fullImage,
      exif: exif,
      config: config,
      watermark: watermark,
    );

    final totalSize = painter.calculateTotalSize(
      Size(
        fullImage.width.toDouble(),
        fullImage.height.toDouble(),
      ),
    );

    // 4. Record to picture.
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    painter.paint(canvas, totalSize);
    final picture = recorder.endRecording();

    // 5. Rasterize.
    final outputImage = await picture.toImage(
      totalSize.width.toInt(),
      totalSize.height.toInt(),
    );

    // 6. Encode.
    if (settings.format == ExportFormat.png) {
      final byteData = await outputImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData!.buffer.asUint8List();
    }

    // JPEG: use the `image` package for quality control.
    final byteData = await outputImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    return _encodeJpeg(
      byteData!,
      totalSize,
      settings.jpegQuality,
    );
  }

  static Uint8List _encodeJpeg(
    ByteData rawRgba,
    Size size,
    int quality,
  ) {
    final width = size.width.toInt();
    final height = size.height.toInt();
    final rgbaBytes = rawRgba.buffer.asUint8List();

    final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgbaBytes.buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );

    return Uint8List.fromList(
      img.encodeJpg(image, quality: quality),
    );
  }
}
