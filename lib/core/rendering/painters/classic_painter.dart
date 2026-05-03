import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class ClassicPainter extends FramePainter {
  ClassicPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
  });

  double get _padding => imageSize.width * frameWeightMultiplier;

  double get _infoPanelHeight => imageSize.width * 0.08;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * frameWeightMultiplier;
    final panelHeight = imageSize.width * 0.08;
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
      _infoPanelHeight,
    );

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = config.backgroundColor,
    );

    final separatorColor =
        ui.Color.lerp(config.accentColor, config.backgroundColor, 0.5) ??
        config.accentColor;

    canvas.drawLine(
      Offset(panelRect.left, panelRect.top),
      Offset(panelRect.right, panelRect.top),
      Paint()
        ..color = separatorColor
        ..strokeWidth = 1,
    );

    paintPhoto(canvas, photoRect);
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final camera = _findValue(fields, 'Camera');
    final settings = [
      _findValue(fields, 'Aperture'),
      _findValue(fields, 'Shutter'),
      _findValue(fields, 'ISO'),
      _findValue(fields, 'Focal Length'),
    ].where((v) => v.isNotEmpty).join(' | ');
    final date = _findValue(fields, 'Date');

    final bodySize = imageSize.width * 0.015;
    final dateSize = imageSize.width * 0.012;
    final inset = imageSize.width * 0.015;

    final cameraTp = buildTextPainter(
      camera,
      fontSize: bodySize,
      color: config.textColor,
      fontWeight: FontWeight.w600,
      maxWidth: panelRect.width * 0.45,
    );
    cameraTp.paint(
      canvas,
      Offset(
        panelRect.left + inset,
        panelRect.top + (panelRect.height - cameraTp.height) / 2,
      ),
    );

    final settingsTp = buildTextPainter(
      settings,
      fontSize: bodySize,
      color: config.textColor,
      textAlign: TextAlign.right,
      maxWidth: panelRect.width * 0.48,
    );
    settingsTp.paint(
      canvas,
      Offset(
        panelRect.right - inset - settingsTp.width,
        panelRect.top + (panelRect.height - settingsTp.height) / 2,
      ),
    );

    if (date.isEmpty) return;
    final dateTp = buildTextPainter(
      date,
      fontSize: dateSize,
      color: config.accentColor,
      textAlign: TextAlign.right,
      maxWidth: panelRect.width * 0.42,
    );
    dateTp.paint(
      canvas,
      Offset(
        panelRect.right - inset - dateTp.width,
        panelRect.bottom - dateTp.height - (inset * 0.2),
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
