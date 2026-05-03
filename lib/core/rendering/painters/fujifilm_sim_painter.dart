import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class FujifilmSimPainter extends FramePainter {
  FujifilmSimPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
  });

  double get _padding => imageSize.width * frameWeightMultiplier;

  double get _panelHeight => imageSize.width * 0.2;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
    final panelHeight = imageSize.width * 0.2;
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

    final cream =
        ui.Color.lerp(
          config.backgroundColor,
          const ui.Color(0xFFF7F2E9),
          0.8,
        ) ??
        config.backgroundColor;
    canvas.drawRect(Offset.zero & totalSize, Paint()..color = cream);

    paintPhoto(canvas, photoRect);

    final card = RRect.fromRectAndRadius(
      panelRect.deflate(imageSize.width * 0.008),
      Radius.circular(imageSize.width * 0.01),
    );
    final panelColor =
        ui.Color.lerp(cream, const ui.Color(0xFFDAF1EC), 0.28) ?? cream;
    canvas.drawRRect(card, Paint()..color = panelColor);

    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final labels = {
      'Camera': _findValue(fields, 'Camera'),
      'Lens': _findValue(fields, 'Lens'),
      'Aperture': _findValue(fields, 'Aperture'),
      'Shutter': _findValue(fields, 'Shutter'),
      'ISO': _findValue(fields, 'ISO'),
      'Focal': _findValue(fields, 'Focal Length'),
      'Date': _findValue(fields, 'Date'),
    };

    final insetX = imageSize.width * 0.022;
    final insetY = imageSize.width * 0.015;
    final textSize = imageSize.width * 0.0135;
    final lineHeight = textSize * 1.4;
    var row = 0;

    for (final item in labels.entries) {
      if (item.value.isEmpty) continue;
      final leader = _leaderDots(item.key, item.value, 30);
      final line = '${item.key}$leader${item.value}';
      final tp = buildTextPainter(
        line,
        fontSize: textSize,
        color: config.textColor,
        maxWidth: panelRect.width - (insetX * 2),
      );
      tp.paint(
        canvas,
        Offset(
          panelRect.left + insetX,
          panelRect.top + insetY + (row * lineHeight),
        ),
      );
      row++;
      if (panelRect.top + insetY + (row * lineHeight) >
          panelRect.bottom - textSize) {
        break;
      }
    }
  }

  String _leaderDots(String left, String right, int width) {
    final dots = width - left.length - right.length;
    if (dots <= 2) return '  ';
    return ' ${'.' * dots} ';
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
