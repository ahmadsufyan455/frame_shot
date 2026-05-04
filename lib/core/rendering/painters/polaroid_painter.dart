import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class PolaroidPainter extends FramePainter {
  PolaroidPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  static const _bgColor = Color(0xFFE2E0DB);
  static const _cardColor = Color(0xFFF9F9F9);
  static const _rotationDeg = -2.0;

  double get _cardPadding => imageSize.width * 0.035;
  double get _cardBottomPadding => imageSize.width * 0.12;

  @override
  Size calculateTotalSize(Size imageSize) {
    final outerPad = imageSize.width * 0.08;
    return Size(
      imageSize.width + (outerPad * 2),
      imageSize.height + (outerPad * 2) +
          (imageSize.width * 0.12),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = _bgColor,
    );

    final cardWidth = totalSize.width * 0.85;
    final cardPhotoHeight =
        (imageSize.height / imageSize.width) *
            (cardWidth - _cardPadding * 2);
    final cardHeight =
        cardPhotoHeight + _cardPadding + _cardBottomPadding;

    final centerX = totalSize.width / 2;
    final centerY = totalSize.height / 2;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(_rotationDeg * math.pi / 180);
    canvas.translate(-centerX, -centerY);

    final cardLeft = (totalSize.width - cardWidth) / 2;
    final cardTop = (totalSize.height - cardHeight) / 2;
    final cardRect = Rect.fromLTWH(
      cardLeft,
      cardTop,
      cardWidth,
      cardHeight,
    );

    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        12,
      );
    canvas.drawRect(cardRect.inflate(2), shadowPaint);
    canvas.drawRect(
      cardRect,
      Paint()..color = _cardColor,
    );

    final photoRect = Rect.fromLTWH(
      cardLeft + _cardPadding,
      cardTop + _cardPadding,
      cardWidth - (_cardPadding * 2),
      cardPhotoHeight,
    );
    paintPhoto(canvas, photoRect);

    _paintCaptionOnCard(canvas, cardRect, photoRect);

    canvas.restore();

    paintWatermark(canvas, totalSize);
  }

  void _paintCaptionOnCard(
    Canvas canvas,
    Rect cardRect,
    Rect photoRect,
  ) {
    final fields = visibleFields;
    final date = _findValue(fields, 'Date');
    final camera = _findValue(fields, 'Camera');

    final parts = <String>[
      if (date.isNotEmpty) date,
      if (camera.isNotEmpty) camera,
    ];
    if (parts.isEmpty) return;

    final caption = parts.join(' \u2022 ');
    final fontSize = imageSize.width * 0.030;

    final tp = TextPainter(
      text: TextSpan(
        text: caption,
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: fontSize,
          fontStyle: FontStyle.italic,
          color: const Color(0xCC525252),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: cardRect.width * 0.9);

    final captionY = photoRect.bottom +
        (_cardBottomPadding - tp.height) / 2;

    tp.paint(
      canvas,
      Offset(
        cardRect.left +
            (cardRect.width - tp.width) / 2,
        captionY,
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
