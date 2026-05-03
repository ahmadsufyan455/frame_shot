import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class MinimalLinePainter extends FramePainter {
  MinimalLinePainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  double get _padding {
    final scaled =
        imageSize.width * frameWeightMultiplier * 0.4;
    final min = imageSize.width * 0.015;
    return scaled < min ? min : scaled;
  }

  double get _panelHeight => imageSize.width * 0.06;

  @override
  Size calculateTotalSize(Size imageSize) {
    final scaled =
        imageSize.width * frameWeightMultiplier * 0.4;
    final min = imageSize.width * 0.015;
    final padding = scaled < min ? min : scaled;
    final panelHeight = imageSize.width * 0.06;
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2) + panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);
    final photoRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );
    final panelRect = Rect.fromLTWH(
      _padding,
      photoRect.bottom,
      imageSize.width,
      _panelHeight,
    );

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = config.backgroundColor,
    );

    canvas.drawRect(
      photoRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = ui.Color.lerp(
              config.accentColor,
              config.backgroundColor,
              0.1,
            ) ??
            config.accentColor,
    );

    paintPhoto(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    // Join all visible field values with a dot
    // separator.
    final line =
        fields.map((f) => f.$2).join(' \u00B7 ');

    final tp = buildTextPainter(
      line,
      fontSize: imageSize.width * 0.015,
      color: config.textColor,
      textAlign: TextAlign.center,
      maxWidth: panelRect.width,
    );

    final centerY =
        panelRect.top +
        (panelRect.height - tp.height) / 2;

    // Camera logo on the left if enabled.
    final logoHeight = _panelHeight * 0.55;
    final logoW = cameraLogoWidth(
      maxHeight: logoHeight,
    );
    final inset = imageSize.width * 0.015;

    if (logoW > 0) {
      paintCameraLogo(
        canvas,
        offset: Offset(
          panelRect.left + inset,
          centerY,
        ),
        maxHeight: logoHeight,
        tintColor: config.textColor,
      );
    }

    tp.paint(
      canvas,
      Offset(
        panelRect.left +
            (panelRect.width - tp.width) / 2,
        centerY,
      ),
    );
  }
}
