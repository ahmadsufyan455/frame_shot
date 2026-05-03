import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/brand_logos.dart';

abstract final class BrandLogoLoader {
  static final Map<String, ui.Image> _cache = {};

  /// Loads the brand logo SVG for [cameraMake] and
  /// rasterizes it to a [ui.Image] at [size] px width.
  /// Returns null if no logo exists for the brand.
  static Future<ui.Image?> load(
    String? cameraMake, {
    int size = 128,
  }) async {
    if (cameraMake == null) return null;

    final key = cameraMake.toLowerCase();
    if (_cache.containsKey(key)) return _cache[key];

    final assetPath = BrandLogos.pathForBrand(key);
    if (assetPath == null) return null;

    try {
      final rawSvg =
          await rootBundle.loadString(assetPath);
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

      final image =
          await recorder.endRecording().toImage(
                size,
                (srcSize.height * scale).round(),
              );
      _cache[key] = image;
      return image;
    } on Exception {
      return null;
    }
  }
}
