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

  double get _padding => imageSize.width * 0.08;
  double get _panelHeight => imageSize.width * 0.08;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding = imageSize.width * 0.08;
    final panelHeight = imageSize.width * 0.08;
    return Size(
      imageSize.width + (padding * 2),
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

    final cardRect = Rect.fromLTWH(
      _padding,
      _padding,
      imageSize.width,
      imageSize.height,
    );

    final shadowPaint = Paint()
      ..color = const ui.Color(0x22000000)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );
    canvas.drawRect(cardRect.inflate(2), shadowPaint);
    canvas.drawRect(cardRect, Paint()..color = _cardColor);

    paintPhoto(canvas, cardRect);

    final panelRect = Rect.fromLTWH(
      _padding,
      cardRect.bottom + (_padding * 0.6),
      imageSize.width,
      _panelHeight,
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final fontSize = imageSize.width * 0.038;
    final centerY =
        panelRect.top + (panelRect.height - fontSize) / 2;

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
      )..layout();
      leftTp.paint(
        canvas,
        Offset(panelRect.left, centerY),
      );
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
    )..layout();
    centerTp.paint(
      canvas,
      Offset(
        panelRect.left +
            (panelRect.width - centerTp.width) / 2,
        centerY,
      ),
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
      )..layout();
      rightTp.paint(
        canvas,
        Offset(
          panelRect.right - rightTp.width,
          centerY,
        ),
      );
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
