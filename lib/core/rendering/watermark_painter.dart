import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class WatermarkLoader {
  static const _assetPath =
      'assets/watermark/frameshot_logo.svg';

  static ui.Image? _cached;

  static Future<ui.Image> load({
    int size = 256,
  }) async {
    if (_cached != null) return _cached!;

    final rawSvg =
        await rootBundle.loadString(_assetPath);
    final pictureInfo = await vg.loadPicture(
      SvgStringLoader(rawSvg),
      null,
    );

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final srcSize = pictureInfo.size;
    final scale = size / srcSize.width;
    canvas.scale(scale, scale);
    canvas.drawPicture(pictureInfo.picture);
    pictureInfo.picture.dispose();

    final image = await recorder.endRecording().toImage(
          size,
          (srcSize.height * scale).round(),
        );
    _cached = image;
    return _cached!;
  }
}
