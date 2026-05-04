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

  static const _bgColor = ui.Color(0xFFFFFFFF);

  double get _padding => imageSize.width * 0.06;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * 0.06;
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2),
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

    final insetAmount = imageSize.width * 0.04;
    final innerBorder = photoRect.deflate(insetAmount);
    canvas.drawRect(
      innerBorder,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = const ui.Color(0x80FFFFFF),
    );

    _paintInfoPill(canvas, photoRect);
    paintWatermark(canvas, totalSize);
  }

  void _paintInfoPill(Canvas canvas, Rect photoRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    final camera = _findValue(fields, 'Camera');
    final focal = _findValue(fields, 'Focal Length');
    final aperture = _findValue(fields, 'Aperture');

    final parts = [camera, focal, aperture]
        .where((s) => s.isNotEmpty)
        .join(' \u2022 ');
    if (parts.isEmpty) return;

    final fontSize = imageSize.width * 0.024;
    final tp = TextPainter(
      text: TextSpan(
        text: parts.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: const ui.Color(0xCC000000),
          letterSpacing: fontSize * 0.12,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: photoRect.width * 0.85);

    final pillPadX = fontSize * 1.5;
    final pillPadY = fontSize * 0.6;
    final pillWidth = tp.width + (pillPadX * 2);
    final pillHeight = tp.height + (pillPadY * 2);

    final pillLeft =
        photoRect.left + (photoRect.width - pillWidth) / 2;
    final pillTop = photoRect.bottom -
        (imageSize.width * 0.04) -
        pillHeight;

    final pillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        pillLeft,
        pillTop,
        pillWidth,
        pillHeight,
      ),
      Radius.circular(pillHeight / 2),
    );

    canvas.drawRRect(
      pillRect,
      Paint()..color = const ui.Color(0x99FFFFFF),
    );

    tp.paint(
      canvas,
      Offset(
        pillLeft + pillPadX,
        pillTop + pillPadY,
      ),
    );
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
