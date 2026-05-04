import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class DarkroomPainter extends FramePainter {
  DarkroomPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  static const _bgColor = ui.Color(0xFF000000);
  static const _innerBg = ui.Color(0xFF18181B);
  static const _textColor = ui.Color(0xFF9CA3AF);

  double get _padding => imageSize.width * frameWeightMultiplier;
  double get _panelHeight => imageSize.width * 0.12;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
    final panelHeight = imageSize.width * 0.12;
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2) + panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(Offset.zero & totalSize, Paint()..color = _bgColor);

    final innerRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );
    canvas.drawRect(innerRect, Paint()..color = _innerBg);

    final photoScale = 0.90;
    final photoW = imageSize.width * photoScale;
    final photoH = imageSize.height * photoScale;
    final photoRect = Rect.fromCenter(
      center: innerRect.center,
      width: photoW,
      height: photoH,
    );
    paintPhoto(canvas, photoRect);

    final panelRect = Rect.fromLTWH(
      _padding,
      innerRect.bottom + (_padding * 0.5),
      imageSize.width,
      _panelHeight,
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    final fontSize = imageSize.width * 0.028;
    final lineGap = fontSize * 0.6;
    final inset = imageSize.width * 0.015;

    final camera = _findValue(fields, 'Camera');
    final lens = _findValue(fields, 'Lens');
    final focal = _findValue(fields, 'Focal Length');
    final aperture = _findValue(fields, 'Aperture');
    final shutter = _findValue(fields, 'Shutter');
    final iso = _findValue(fields, 'ISO');

    final topY = panelRect.top + inset;
    final bottomY = topY + fontSize + lineGap;

    if (camera.isNotEmpty) {
      _paintMono(
        canvas,
        camera,
        fontSize,
        Offset(panelRect.left + inset, topY),
      );
    }
    if (lens.isNotEmpty) {
      _paintMono(
        canvas,
        lens,
        fontSize,
        Offset(panelRect.left + inset, bottomY),
      );
    }

    final rightParts = [
      focal,
      aperture,
      shutter,
    ].where((s) => s.isNotEmpty).join(' \u2022 ');

    if (rightParts.isNotEmpty) {
      final tp = _buildMono(rightParts, fontSize);
      tp.paint(canvas, Offset(panelRect.right - inset - tp.width, topY));
    }
    if (iso.isNotEmpty) {
      final tp = _buildMono(iso, fontSize);
      tp.paint(canvas, Offset(panelRect.right - inset - tp.width, bottomY));
    }
  }

  void _paintMono(Canvas canvas, String text, double fontSize, Offset offset) {
    final tp = _buildMono(text, fontSize);
    tp.paint(canvas, offset);
  }

  TextPainter _buildMono(String text, double fontSize) {
    return TextPainter(
      text: TextSpan(
        text: text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          color: _textColor,
          fontWeight: FontWeight.w400,
          letterSpacing: fontSize * 0.12,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: imageSize.width * 0.48);
  }

  String _findValue(List<(String, String)> fields, String label) {
    for (final entry in fields) {
      if (entry.$1 == label) return entry.$2;
    }
    return '';
  }
}
