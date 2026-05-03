import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class ArchitectPainter extends FramePainter {
  ArchitectPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  double get _padding =>
      imageSize.width * frameWeightMultiplier;

  double get _panelHeight => imageSize.width * 0.09;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding =
        imageSize.width * frameWeightMultiplier;
    final panelHeight = imageSize.width * 0.09;
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

    final blueprint = ui.Color.lerp(
          config.backgroundColor,
          const ui.Color(0xFF0C1E3A),
          0.8,
        ) ??
        config.backgroundColor;
    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = blueprint,
    );

    paintPhoto(canvas, photoRect);
    _paintGridOverlay(canvas, photoRect);
    _paintCornerCrosshair(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    final inset = imageSize.width * 0.015;
    final centerY =
        panelRect.top + (panelRect.height / 2);

    // Camera logo on the far right.
    final logoHeight = _panelHeight * 0.5;
    final logoW = cameraLogoWidth(
      maxHeight: logoHeight,
    );
    if (logoW > 0) {
      paintCameraLogo(
        canvas,
        offset: Offset(
          panelRect.right - inset - logoW,
          centerY - (logoHeight / 2),
        ),
        maxHeight: logoHeight,
        tintColor: config.accentColor,
      );
    }

    // Left side: all fields in bracketed format,
    // excluding Camera (shown separately on right).
    final camera = fields
        .where((f) => f.$1 == 'Camera')
        .map((f) => f.$2)
        .firstOrNull;

    final bits = fields
        .where((f) => f.$1 != 'Camera')
        .map((f) => '[${f.$2}]')
        .join(' ');

    if (bits.isNotEmpty) {
      final tp = buildTextPainter(
        bits,
        fontSize: imageSize.width * 0.014,
        color: config.textColor,
        maxWidth: panelRect.width - (inset * 2),
      );
      tp.paint(
        canvas,
        Offset(
          panelRect.left + inset,
          centerY - (tp.height / 2),
        ),
      );
    }

    // Camera name on the right (before logo).
    if (camera != null && camera.isNotEmpty) {
      final rightEdge = logoW > 0
          ? panelRect.right - inset - logoW - inset
          : panelRect.right - inset;
      final cameraTp = buildTextPainter(
        camera,
        fontSize: imageSize.width * 0.012,
        color: config.accentColor,
        textAlign: TextAlign.right,
        maxWidth: panelRect.width * 0.35,
      );
      cameraTp.paint(
        canvas,
        Offset(
          rightEdge - cameraTp.width,
          centerY - (cameraTp.height / 2),
        ),
      );
    }
  }

  void _paintGridOverlay(
    Canvas canvas,
    Rect photoRect,
  ) {
    final paint = Paint()
      ..color = ui.Color.fromARGB(110, 255, 255, 255)
      ..strokeWidth = 1;
    final thirdX = photoRect.width / 3;
    final thirdY = photoRect.height / 3;

    for (var i = 1; i <= 2; i++) {
      final x = photoRect.left + (thirdX * i);
      final y = photoRect.top + (thirdY * i);
      canvas.drawLine(
        Offset(x, photoRect.top),
        Offset(x, photoRect.bottom),
        paint,
      );
      canvas.drawLine(
        Offset(photoRect.left, y),
        Offset(photoRect.right, y),
        paint,
      );
    }
  }

  void _paintCornerCrosshair(
    Canvas canvas,
    Rect photoRect,
  ) {
    final len = imageSize.width * 0.02;
    final markerColor = ui.Color.lerp(
          config.accentColor,
          const ui.Color(0xFFFFFFFF),
          0.2,
        ) ??
        config.accentColor;
    final paint = Paint()
      ..color = markerColor
      ..strokeWidth = 1.5;

    _drawCorner(
      canvas,
      photoRect.topLeft,
      len,
      true,
      true,
      paint,
    );
    _drawCorner(
      canvas,
      photoRect.topRight,
      len,
      false,
      true,
      paint,
    );
    _drawCorner(
      canvas,
      photoRect.bottomLeft,
      len,
      true,
      false,
      paint,
    );
    _drawCorner(
      canvas,
      photoRect.bottomRight,
      len,
      false,
      false,
      paint,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Offset point,
    double len,
    bool left,
    bool top,
    Paint paint,
  ) {
    final xDir = left ? 1 : -1;
    final yDir = top ? 1 : -1;
    canvas.drawLine(
      point,
      Offset(point.dx + (len * xDir), point.dy),
      paint,
    );
    canvas.drawLine(
      point,
      Offset(point.dx, point.dy + (len * yDir)),
      paint,
    );
  }
}
