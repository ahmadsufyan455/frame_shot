import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../frame_painter.dart';

class ClassicPainter extends FramePainter {
  ClassicPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  static const _bgColor = ui.Color(0xFFFFFFFF);
  static const _photoBg = ui.Color(0xFFF5F5F5);
  static const _textPrimary = ui.Color(0xFF000000);
  static const _textSecondary = ui.Color(0xFF737373);

  double get _padding => imageSize.width * frameWeightMultiplier;
  double get _gap => imageSize.width * 0.025;

  double _measuredPanelHeight(Size imgSize) {
    final bodySize = imgSize.width * 0.038;
    final maxWidth = imgSize.width * 0.4;
    final fields = visibleFields;
    final camera = _findValue(fields, 'Camera');

    if (camera.isEmpty) return imgSize.width * 0.08;

    final tp = TextPainter(
      text: TextSpan(
        text: camera,
        style: TextStyle(fontSize: bodySize, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '\u2026',
    )..layout(maxWidth: maxWidth);

    final inset = imgSize.width * 0.01;
    final height = tp.height + (inset * 2);
    final minHeight = imgSize.width * 0.08;
    return height > minHeight ? height : minHeight;
  }

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
    final panelHeight = _measuredPanelHeight(imageSize);
    final gap = imageSize.width * 0.025;
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2) + gap + panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(Offset.zero & totalSize, Paint()..color = _bgColor);

    final photoRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );

    final photoRRect = RRect.fromRectAndRadius(
      photoRect,
      const Radius.circular(2),
    );
    canvas.drawRRect(photoRRect, Paint()..color = _photoBg);
    canvas.save();
    canvas.clipRRect(photoRRect);
    paintPhoto(canvas, photoRect);
    canvas.restore();

    final panelRect = Rect.fromLTWH(
      _padding,
      photoRect.bottom + _gap,
      imageSize.width,
      _measuredPanelHeight(imageSize),
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    if (fields.isEmpty) return;

    final inset = imageSize.width * 0.01;
    final centerY = panelRect.top + (panelRect.height / 2);
    final bodySize = imageSize.width * 0.038;
    final smallSize = imageSize.width * 0.032;

    final iconSize = panelRect.height * 0.55;
    var leftX = panelRect.left + inset;

    _paintCameraIcon(
      canvas,
      Rect.fromLTWH(leftX, centerY - iconSize / 2, iconSize, iconSize),
    );
    leftX += iconSize + (inset * 1.5);

    final camera = _findValue(fields, 'Camera');
    final leftMaxWidth = panelRect.width * 0.4;

    if (camera.isNotEmpty) {
      final tp = buildTextPainter(
        camera,
        fontSize: bodySize,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
        maxWidth: leftMaxWidth,
        maxLines: 2,
      );
      tp.paint(canvas, Offset(leftX, centerY - tp.height / 2));
    }

    final focal = _findValue(fields, 'Focal Length');
    final aperture = _findValue(fields, 'Aperture');
    final shutter = _findValue(fields, 'Shutter');
    final iso = _findValue(fields, 'ISO');

    final topRight = [focal, aperture].where((s) => s.isNotEmpty).join('     ');
    final bottomRight = [shutter, iso].where((s) => s.isNotEmpty).join('     ');

    final rightX = panelRect.right - inset;
    final rightMaxWidth = panelRect.width * 0.45;

    if (topRight.isNotEmpty) {
      final tp = buildTextPainter(
        topRight,
        fontSize: bodySize * 0.9,
        fontWeight: FontWeight.w500,
        color: _textPrimary,
        maxWidth: rightMaxWidth,
      );
      tp.paint(canvas, Offset(rightX - tp.width, centerY - tp.height - 1));
    }

    if (bottomRight.isNotEmpty) {
      final tp = buildTextPainter(
        bottomRight,
        fontSize: smallSize,
        color: _textSecondary,
        maxWidth: rightMaxWidth,
      );
      tp.paint(canvas, Offset(rightX - tp.width, centerY + 1));
    }
  }

  String _findValue(List<(String, String)> fields, String label) {
    for (final entry in fields) {
      if (entry.$1 == label) return entry.$2;
    }
    return '';
  }

  void _paintCameraIcon(Canvas canvas, Rect rect) {
    final center = rect.center;
    final circleR = rect.width * 0.5;
    canvas.drawCircle(center, circleR, Paint()..color = _photoBg);

    const icon = Icons.camera_alt_outlined;
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: _textPrimary,
          fontFamily: icon.fontFamily,
          fontSize: rect.width * 0.7,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }
}
