import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class DarkroomPainter extends FramePainter {
  DarkroomPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
  });

  double get _padding => imageSize.width * frameWeightMultiplier * 1.2;

  double get _panelHeight => imageSize.width * 0.18;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier * 1.2;
    final panelHeight = imageSize.width * 0.18;
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

    final borderColor = ui.Color.fromARGB(180, 255, 255, 255);
    canvas.drawRect(
      Rect.fromLTWH(
        _padding * 0.5,
        _padding * 0.5,
        totalSize.width - _padding,
        totalSize.height - _padding,
      ),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = imageSize.width * 0.003,
    );

    paintPhoto(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final textSize = imageSize.width * 0.014;
    final rowGap = textSize * 0.6;
    final inset = imageSize.width * 0.018;
    final colWidth = (panelRect.width - (inset * 3)) / 2;

    var row = 0;
    for (var i = 0; i < fields.length; i++) {
      final col = i % 2;
      if (col == 0 && i > 0) {
        row++;
      }
      final x = panelRect.left + inset + (col * (colWidth + inset));
      final y = panelRect.top + inset + (row * (textSize + rowGap));
      final line = '${fields[i].$1.toUpperCase()}: ${fields[i].$2}';
      final tp = buildTextPainter(
        line,
        fontSize: textSize,
        color: config.textColor,
        maxWidth: colWidth,
      );
      tp.paint(canvas, Offset(x, y));
    }
  }
}
