import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class FujifilmSimPainter extends FramePainter {
  FujifilmSimPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  static const _bgColor = ui.Color(0xFFF2EFE9);
  static const _cardColor = ui.Color(0xFFFFFFFF);
  static const _textColor = ui.Color(0xFF1E3A3A);

  double get _padding => imageSize.width * frameWeightMultiplier;

  double _measuredPanelHeight(Size imgSize) {
    final fontSize = imgSize.width * 0.038;
    // Measure camera text (longest potential text) with 2 lines
    final fields = visibleFields;
    final camera = _findValue(fields, 'Camera');
    final columnWidth = imgSize.width * 0.35;

    final tp = TextPainter(
      text: TextSpan(
        text: camera.isNotEmpty ? camera : 'X',
        style: TextStyle(fontFamily: 'serif', fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '\u2026',
    )..layout(maxWidth: columnWidth);

    final verticalPad = imgSize.width * 0.02;
    final height = tp.height + (verticalPad * 2);
    final minHeight = imgSize.width * 0.08;
    return height > minHeight ? height : minHeight;
  }

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
    final panelHeight = _measuredPanelHeight(imageSize);
    return Size(
      imageSize.width + (padding * 2),
      imageSize.height + (padding * 2) + panelHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(Offset.zero & totalSize, Paint()..color = _bgColor);

    final cardRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );

    final shadowPaint = Paint()
      ..color = const ui.Color(0x22000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRect(cardRect.inflate(2), shadowPaint);
    canvas.drawRect(cardRect, Paint()..color = _cardColor);

    paintPhoto(canvas, cardRect);

    final panelRect = Rect.fromLTWH(
      _padding,
      cardRect.bottom + (_padding * 0.6),
      imageSize.width,
      _measuredPanelHeight(imageSize),
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final fontSize = imageSize.width * 0.038;
    final columnWidth = panelRect.width * 0.35;

    final camera = _findValue(fields, 'Camera');
    final focal = _findValue(fields, 'Focal Length');

    if (camera.isNotEmpty) {
      final leftTp = TextPainter(
        text: TextSpan(
          text: camera,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: fontSize,
            fontStyle: FontStyle.italic,
            color: _textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '\u2026',
      )..layout(maxWidth: columnWidth);
      final leftY = panelRect.top + (panelRect.height - leftTp.height) / 2;
      leftTp.paint(canvas, Offset(panelRect.left, leftY));
    }

    final centerTp = TextPainter(
      text: TextSpan(
        text: 'Classic Chrome',
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: fontSize,
          fontStyle: FontStyle.italic,
          color: _textColor,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '\u2026',
    )..layout(maxWidth: panelRect.width * 0.4);
    final centerY = panelRect.top + (panelRect.height - centerTp.height) / 2;
    centerTp.paint(
      canvas,
      Offset(panelRect.left + (panelRect.width - centerTp.width) / 2, centerY),
    );

    if (focal.isNotEmpty) {
      final rightTp = TextPainter(
        text: TextSpan(
          text: focal,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: fontSize,
            fontStyle: FontStyle.italic,
            color: _textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '\u2026',
      )..layout(maxWidth: columnWidth);
      final rightY = panelRect.top + (panelRect.height - rightTp.height) / 2;
      rightTp.paint(canvas, Offset(panelRect.right - rightTp.width, rightY));
    }
  }

  String _findValue(List<(String, String)> fields, String label) {
    for (final entry in fields) {
      if (entry.$1 == label) return entry.$2;
    }
    return '';
  }
}
