import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class FilmBorderPainter extends FramePainter {
  FilmBorderPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  double get _basePadding =>
      imageSize.width * frameWeightMultiplier;

  double get _sidePadding => _basePadding * 2.1;

  double get _panelHeight => imageSize.width * 0.1;

  @override
  Size calculateTotalSize(Size imageSize) {
    final basePadding =
        imageSize.width * frameWeightMultiplier;
    final sidePadding = basePadding * 2.1;
    final panelHeight = imageSize.width * 0.1;
    return Size(
      imageSize.width + (sidePadding * 2),
      imageSize.height +
          (basePadding * 2) +
          panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);
    final photoRect = Rect.fromLTWH(
      _sidePadding,
      _basePadding,
      imageSize.width,
      imageSize.height,
    );
    final panelRect = Rect.fromLTWH(
      _sidePadding,
      photoRect.bottom,
      imageSize.width,
      _panelHeight,
    );

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = config.backgroundColor,
    );

    _paintSprocketColumns(canvas, totalSize);
    paintPhoto(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    final bodySize = imageSize.width * 0.014;
    final insetX = imageSize.width * 0.015;
    final warmText = _blend(
      config.textColor,
      const ui.Color(0xFFD8B784),
      0.5,
    );
    final accent = _blend(
      config.accentColor,
      const ui.Color(0xFF8C6A3A),
      0.4,
    );

    // -- Top row: logo + primary info --
    final logoHeight = _panelHeight * 0.35;
    var leftX = panelRect.left + insetX;

    final logoW = cameraLogoWidth(
      maxHeight: logoHeight,
    );
    if (logoW > 0) {
      paintCameraLogo(
        canvas,
        offset: Offset(leftX, panelRect.top + 4),
        maxHeight: logoHeight,
        tintColor: warmText,
      );
      leftX += logoW + (insetX * 0.5);
    }

    final primaryParts = fields
        .where(
          (f) =>
              f.$1 == 'Camera' ||
              f.$1 == 'Lens' ||
              f.$1 == 'Date',
        )
        .map((f) => f.$2);
    final mainBits = primaryParts.join('   ');

    if (mainBits.isNotEmpty) {
      final mainTp = buildTextPainter(
        mainBits,
        fontSize: bodySize,
        color: warmText,
        maxWidth: panelRect.width - leftX +
            panelRect.left -
            insetX,
      );
      mainTp.paint(
        canvas,
        Offset(leftX, panelRect.top + 4),
      );
    }

    // -- Bottom row: all other settings --
    final settingParts = fields
        .where(
          (f) =>
              f.$1 != 'Camera' &&
              f.$1 != 'Lens' &&
              f.$1 != 'Date',
        )
        .map((f) => f.$2);
    final settings = settingParts.join(' | ');

    if (settings.isNotEmpty) {
      final settingsTp = buildTextPainter(
        settings,
        fontSize: bodySize * 0.95,
        color: accent,
        maxWidth: panelRect.width - (insetX * 2),
      );
      settingsTp.paint(
        canvas,
        Offset(
          panelRect.left + insetX,
          panelRect.bottom -
              settingsTp.height -
              4,
        ),
      );
    }
  }

  void _paintSprocketColumns(
    Canvas canvas,
    Size totalSize,
  ) {
    final count = 10;
    final holeWidth = _sidePadding * 0.38;
    final holeHeight =
        imageSize.height / (count * 1.65);
    final top = _basePadding + (holeHeight * 0.3);
    final usableHeight =
        imageSize.height - (holeHeight * 0.6);
    final spacing = usableHeight / count;
    final paint = Paint()
      ..color = ui.Color.fromARGB(180, 0, 0, 0);

    for (var i = 0; i < count; i++) {
      final y = top + (i * spacing);
      final leftRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (_sidePadding - holeWidth) * 0.5,
          y,
          holeWidth,
          holeHeight,
        ),
        Radius.circular(holeWidth * 0.2),
      );
      final rightRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          totalSize.width -
              _sidePadding +
              ((_sidePadding - holeWidth) * 0.5),
          y,
          holeWidth,
          holeHeight,
        ),
        Radius.circular(holeWidth * 0.2),
      );
      canvas.drawRRect(leftRect, paint);
      canvas.drawRRect(rightRect, paint);
    }
  }

  ui.Color _blend(ui.Color a, ui.Color b, double t) {
    return ui.Color.lerp(a, b, t) ?? a;
  }
}
