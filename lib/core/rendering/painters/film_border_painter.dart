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

  static const _bgColor = ui.Color(0xFF1A1A1A);
  static const _borderColor = ui.Color(0xFF0A0A0A);
  static const _goldText = ui.Color(0xFFF2CB05);

  double get _padding => imageSize.width * 0.04;
  double get _sideBorder => imageSize.width * 0.04;
  double get _panelHeight => imageSize.width * 0.08;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * 0.04;
    final sideBorder = imageSize.width * 0.04;
    final panelHeight = imageSize.width * 0.08;
    return Size(
      imageSize.width + (padding * 2) + (sideBorder * 2),
      imageSize.height + (padding * 2) + panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = _bgColor,
    );

    final borderLeft = _padding;
    final borderRight = totalSize.width - _padding;
    canvas.drawRect(
      Rect.fromLTWH(
        borderLeft,
        0,
        _sideBorder,
        totalSize.height,
      ),
      Paint()..color = _borderColor,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        borderRight - _sideBorder,
        0,
        _sideBorder,
        totalSize.height,
      ),
      Paint()..color = _borderColor,
    );

    _paintSprocketHoles(canvas, totalSize);

    final photoRect = Rect.fromLTWH(
      _padding + _sideBorder,
      _padding,
      imageSize.width,
      imageSize.height,
    );
    paintPhoto(canvas, photoRect);

    final panelRect = Rect.fromLTWH(
      _padding + _sideBorder,
      photoRect.bottom + (_padding * 0.5),
      imageSize.width,
      _panelHeight,
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final fontSize = imageSize.width * 0.022;
    final gap = imageSize.width * 0.02;
    final centerY =
        panelRect.top +
        (panelRect.height - fontSize) / 2;

    final leftTp = _buildGoldText(
      'KODAK PORTRA 400',
      fontSize,
    );
    leftTp.paint(
      canvas,
      Offset(panelRect.left, centerY),
    );

    final rightTp = _buildGoldText('36', fontSize);
    rightTp.paint(
      canvas,
      Offset(panelRect.right - rightTp.width, centerY),
    );

    final aperture = _findValue(fields, 'Aperture');
    final shutter = _findValue(fields, 'Shutter');
    final camera = _findValue(fields, 'Camera');
    final centerParts = [aperture, shutter, camera]
        .where((s) => s.isNotEmpty)
        .join('  ');

    if (centerParts.isNotEmpty) {
      final leftEdge = panelRect.left + leftTp.width + gap;
      final rightEdge =
          panelRect.right - rightTp.width - gap;
      final availableWidth = rightEdge - leftEdge;

      if (availableWidth > fontSize * 2) {
        final centerTp = TextPainter(
          text: TextSpan(
            text: centerParts.toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: _goldText,
              letterSpacing: fontSize * 0.05,
            ),
          ),
          textDirection: TextDirection.ltr,
          maxLines: 1,
          ellipsis: '\u2026',
        )..layout(maxWidth: availableWidth);

        final centerX =
            leftEdge + (availableWidth - centerTp.width) / 2;
        centerTp.paint(
          canvas,
          Offset(centerX, centerY),
        );
      }
    }
  }

  TextPainter _buildGoldText(
    String text,
    double fontSize,
  ) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: _goldText,
          letterSpacing: fontSize * 0.1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  void _paintSprocketHoles(
    Canvas canvas,
    Size totalSize,
  ) {
    final count = 12;
    final holeWidth = _sideBorder * 0.5;
    final holeHeight = totalSize.height / (count * 2);
    final spacing = totalSize.height / count;
    final paint = Paint()..color = _bgColor;

    for (var i = 0; i < count; i++) {
      final y =
          (i * spacing) + (spacing - holeHeight) / 2;

      final leftRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          _padding + (_sideBorder - holeWidth) / 2,
          y,
          holeWidth,
          holeHeight,
        ),
        const Radius.circular(1),
      );
      final rightRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          totalSize.width -
              _padding -
              _sideBorder +
              (_sideBorder - holeWidth) / 2,
          y,
          holeWidth,
          holeHeight,
        ),
        const Radius.circular(1),
      );
      canvas.drawRRect(leftRect, paint);
      canvas.drawRRect(rightRect, paint);
    }
  }

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
