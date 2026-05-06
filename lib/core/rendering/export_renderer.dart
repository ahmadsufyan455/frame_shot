import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:image/image.dart' as img;

import '../constants/app_constants.dart';
import '../models/exif_data.dart';
import '../models/export_settings.dart';
import '../models/frame_config.dart';
import '../models/frame_style.dart';
import 'brand_logo_loader.dart';
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
    final bytes = await File(sourceImagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: isPro ? null : ImageConstants.freeMaxDimension,
    );
    final frame = await codec.getNextFrame();
    final fullImage = frame.image;

    try {
      // 2. Load watermark for free tier.
      final ui.Image? watermark = isPro ? null : await WatermarkLoader.load();

      // 3. Load camera logo if enabled.
      final ui.Image? cameraLogo = config.showCameraLogo
          ? await BrandLogoLoader.load(exif.cameraMake, size: 256)
          : null;

      // 4. Create painter at full resolution.
      final painter = FramePainterFactory.create(
        styleId: styleId,
        image: fullImage,
        exif: exif,
        config: config,
        watermark: watermark,
        cameraLogo: cameraLogo,
      );

      final totalSize = painter.calculateTotalSize(painter.imageSize);

      // 5. Record to picture.
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      painter.paint(canvas, totalSize);
      final picture = recorder.endRecording();

      try {
        // 6. Rasterize.
        final outputImage = await picture.toImage(
          totalSize.width.toInt(),
          totalSize.height.toInt(),
        );

        try {
          // 7. Encode.
          if (settings.format == ExportFormat.png) {
            final byteData = await outputImage.toByteData(
              format: ui.ImageByteFormat.png,
            );
            return byteData!.buffer.asUint8List();
          }

          // JPEG: encode on a background isolate to avoid
          // blocking the UI thread during heavy pixel work.
          final byteData = await outputImage.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          return Isolate.run(
            () => _encodeJpeg(
              byteData!.buffer.asUint8List(),
              totalSize.width.toInt(),
              totalSize.height.toInt(),
              settings.jpegQuality,
            ),
          );
        } finally {
          outputImage.dispose();
        }
      } finally {
        picture.dispose();
      }
    } finally {
      fullImage.dispose();
    }
  }

  static Uint8List _encodeJpeg(
    Uint8List rgbaBytes,
    int width,
    int height,
    int quality,
  ) {
    final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgbaBytes.buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );

    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }
}
