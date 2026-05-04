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

  static const _bgColor = ui.Color(0xFF0A0A0A);
  static const _red = ui.Color(0xFFEF4444);
  static const _redDim = ui.Color(0x4DEF4444);
  static const _redBg = ui.Color(0x0DEF4444);

  double get _padding => imageSize.width * 0.04;
  double get _hudHeight => imageSize.width * 0.10;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * 0.04;
    final hudHeight = imageSize.width * 0.10;
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2) + hudHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = _bgColor,
    );

    final photoRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );
    paintPhoto(canvas, photoRect);

    _paintGridOverlay(canvas, photoRect);
    _paintViewfinderCorners(canvas, photoRect);
    _paintCrosshair(canvas, photoRect);

    final hudRect = Rect.fromLTWH(
      _padding,
      photoRect.bottom + (_padding * 0.3),
      imageSize.width,
      _hudHeight,
    );
    _paintHud(canvas, hudRect);
    paintWatermark(canvas, totalSize);
  }

  void _paintGridOverlay(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = const ui.Color(0x26FFFFFF)
      ..strokeWidth = 1;
    final stepX = rect.width / 10;
    final stepY = rect.height / 10;

    for (var i = 1; i < 10; i++) {
      canvas.drawLine(
        Offset(rect.left + stepX * i, rect.top),
        Offset(rect.left + stepX * i, rect.bottom),
        paint,
      );
      canvas.drawLine(
        Offset(rect.left, rect.top + stepY * i),
        Offset(rect.right, rect.top + stepY * i),
        paint,
      );
    }
  }

  void _paintViewfinderCorners(
    Canvas canvas,
    Rect rect,
  ) {
    final len = imageSize.width * 0.03;
    final paint = Paint()
      ..color = _red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawCorner(canvas, rect.topLeft, len, 1, 1, paint);
    _drawCorner(
      canvas, rect.topRight, len, -1, 1, paint,
    );
    _drawCorner(
      canvas, rect.bottomLeft, len, 1, -1, paint,
    );
    _drawCorner(
      canvas, rect.bottomRight, len, -1, -1, paint,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Offset point,
    double len,
    int xDir,
    int yDir,
    Paint paint,
  ) {
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

  void _paintCrosshair(Canvas canvas, Rect rect) {
    final center = rect.center;
    final armLen = imageSize.width * 0.025;
    final paint = Paint()
      ..color = _red.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(center.dx - armLen, center.dy),
      Offset(center.dx + armLen, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - armLen),
      Offset(center.dx, center.dy + armLen),
      paint,
    );
  }

  void _paintHud(Canvas canvas, Rect hudRect) {
    final fields = visibleFields;
    final camera = _findValue(fields, 'Camera');
    final focal = _findValue(fields, 'Focal Length');
    final aperture = _findValue(fields, 'Aperture');
    final shutter = _findValue(fields, 'Shutter');
    final iso = _findValue(fields, 'ISO');

    final cells = [
      ('CAM', camera),
      ('LENS', focal),
      ('EXP', '$aperture $shutter'.trim()),
      ('ISO', iso),
    ];

    final gap = imageSize.width * 0.005;
    final cellWidth =
        (hudRect.width - (gap * 3)) / 4;
    final cellHeight = hudRect.height;

    final labelSize = imageSize.width * 0.022;
    final valueSize = imageSize.width * 0.025;

    for (var i = 0; i < cells.length; i++) {
      final x = hudRect.left + (i * (cellWidth + gap));
      final cellRect = Rect.fromLTWH(
        x,
        hudRect.top,
        cellWidth,
        cellHeight,
      );

      canvas.drawRect(cellRect, Paint()..color = _redBg);
      canvas.drawRect(
        cellRect,
        Paint()
          ..color = _redDim
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      final labelTp = TextPainter(
        text: TextSpan(
          text: cells[i].$1,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: labelSize,
            color: _red.withValues(alpha: 0.6),
            letterSpacing: labelSize * 0.2,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: cellWidth);

      labelTp.paint(
        canvas,
        Offset(
          cellRect.center.dx - labelTp.width / 2,
          cellRect.top + cellHeight * 0.15,
        ),
      );

      final valueTp = TextPainter(
        text: TextSpan(
          text: cells[i].$2.toUpperCase(),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: valueSize,
            fontWeight: FontWeight.w700,
            color: _red,
            letterSpacing: valueSize * 0.05,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: cellWidth - 4);

      valueTp.paint(
        canvas,
        Offset(
          cellRect.center.dx - valueTp.width / 2,
          cellRect.center.dy,
        ),
      );
    }
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {}

  String _findValue(
    List<(String, String)> fields,
    String label,
  ) {
    for (final entry in fields) {
      if (entry.$1 == label) return entry.$2;
    }
    return '';
  }
}
