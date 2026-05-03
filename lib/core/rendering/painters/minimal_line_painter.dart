import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class MinimalLinePainter extends FramePainter {
  MinimalLinePainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
  });

  double get _padding {
    final scaled = imageSize.width * frameWeightMultiplier * 0.4;
    final min = imageSize.width * 0.015;
    return scaled < min ? min : scaled;
  }

  double get _panelHeight => imageSize.width * 0.06;

  @override
  Size calculateTotalSize(Size imageSize) {
    final scaled = imageSize.width * frameWeightMultiplier * 0.4;
    final min = imageSize.width * 0.015;
    final padding = scaled < min ? min : scaled;
    final panelHeight = imageSize.width * 0.06;
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

    canvas.drawRect(
      photoRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color =
            ui.Color.lerp(config.accentColor, config.backgroundColor, 0.1) ??
            config.accentColor,
    );

    paintPhoto(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final line = [
      _findValue(fields, 'Aperture'),
      _findValue(fields, 'Shutter'),
      _findValue(fields, 'ISO'),
      _findValue(fields, 'Focal Length'),
    ].where((v) => v.isNotEmpty).join(' · ');

    final tp = buildTextPainter(
      line,
      fontSize: imageSize.width * 0.015,
      color: config.textColor,
      textAlign: TextAlign.center,
      maxWidth: panelRect.width,
    );
    tp.paint(
      canvas,
      Offset(
        panelRect.left + (panelRect.width - tp.width) / 2,
        panelRect.top + (panelRect.height - tp.height) / 2,
      ),
    );
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
