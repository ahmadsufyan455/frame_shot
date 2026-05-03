import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class ArchitectPainter extends FramePainter {
  ArchitectPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
  });

  double get _padding => imageSize.width * frameWeightMultiplier;

  double get _panelHeight => imageSize.width * 0.09;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
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

    final blueprint =
        ui.Color.lerp(
          config.backgroundColor,
          const ui.Color(0xFF0C1E3A),
          0.8,
        ) ??
        config.backgroundColor;
    canvas.drawRect(Offset.zero & totalSize, Paint()..color = blueprint);

    paintPhoto(canvas, photoRect);
    _paintGridOverlay(canvas, photoRect);
    _paintCornerCrosshair(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final bits = [
      _findValue(fields, 'ISO').isEmpty
          ? ''
          : '[ISO ${_findValue(fields, 'ISO')}]',
      _findValue(fields, 'Aperture').isEmpty
          ? ''
          : '[${_findValue(fields, 'Aperture')}]',
      _findValue(fields, 'Shutter').isEmpty
          ? ''
          : '[${_findValue(fields, 'Shutter')}]',
      _findValue(fields, 'Focal Length').isEmpty
          ? ''
          : '[${_findValue(fields, 'Focal Length')}]',
    ].where((v) => v.isNotEmpty).join(' ');

    final tp = buildTextPainter(
      bits,
      fontSize: imageSize.width * 0.014,
      color: config.textColor,
      maxWidth: panelRect.width - (imageSize.width * 0.03),
    );
    tp.paint(
      canvas,
      Offset(
        panelRect.left + imageSize.width * 0.015,
        panelRect.top + (panelRect.height - tp.height) / 2,
      ),
    );

    final camera = _findValue(fields, 'Camera');
    if (camera.isEmpty) return;
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
        panelRect.right - cameraTp.width - (imageSize.width * 0.015),
        panelRect.top + (panelRect.height - cameraTp.height) / 2,
      ),
    );
  }

  void _paintGridOverlay(Canvas canvas, Rect photoRect) {
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

  void _paintCornerCrosshair(Canvas canvas, Rect photoRect) {
    final len = imageSize.width * 0.02;
    final markerColor =
        ui.Color.lerp(config.accentColor, const ui.Color(0xFFFFFFFF), 0.2) ??
        config.accentColor;
    final paint = Paint()
      ..color = markerColor
      ..strokeWidth = 1.5;

    _drawCorner(canvas, photoRect.topLeft, len, true, true, paint);
    _drawCorner(canvas, photoRect.topRight, len, false, true, paint);
    _drawCorner(canvas, photoRect.bottomLeft, len, true, false, paint);
    _drawCorner(canvas, photoRect.bottomRight, len, false, false, paint);
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
    canvas.drawLine(point, Offset(point.dx + (len * xDir), point.dy), paint);
    canvas.drawLine(point, Offset(point.dx, point.dy + (len * yDir)), paint);
  }

  String _findValue(List<(String, String)> fields, String label) {
    for (final entry in fields) {
      if (entry.$1 == label) {
        return entry.$2;
      }
    }
    return '';
  }
}
