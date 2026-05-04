import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class EditorialPainter extends FramePainter {
  EditorialPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  static const _bgColor = Color(0xFFFFFFFF);
  static const _textColor = Color(0xFF000000);
  static const _subtextColor = Color(0xFF737373);

  double get _horizontalPadding => imageSize.width * 0.04;
  double get _topPadding => imageSize.width * 0.04;
  double get _panelHeight => imageSize.width * 0.16;

  @override
  Size calculateTotalSize(Size imageSize) {
    final hPad = imageSize.width * 0.04;
    final tPad = imageSize.width * 0.04;
    final panel = imageSize.width * 0.16;
    return Size(
      imageSize.width + (hPad * 2),
      imageSize.height + tPad + panel,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalSize = calculateTotalSize(imageSize);

    canvas.drawRect(
      Offset.zero & totalSize,
      Paint()..color = _bgColor,
    );

    final photoRect = Rect.fromLTWH(
      _horizontalPadding,
      _topPadding,
      imageSize.width,
      imageSize.height,
    );
    paintPhoto(canvas, photoRect);

    final panelRect = Rect.fromLTWH(
      0,
      photoRect.bottom,
      totalSize.width,
      _panelHeight,
    );
    paintInfoPanel(canvas, panelRect);
    paintWatermark(canvas, totalSize);
  }

  @override
  void paintInfoPanel(Canvas canvas, Rect panelRect) {
    final fields = visibleFields;
    final centerX = panelRect.center.dx;
    final centerY = panelRect.center.dy;

    final camera = _findValue(fields, 'Camera');
    final make = exif.cameraMake ?? '';
    final brandName = make.isNotEmpty ? make : camera;

    if (brandName.isNotEmpty) {
      final brandTp = TextPainter(
        text: TextSpan(
          text: brandName.toUpperCase(),
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: imageSize.width * 0.055,
            fontWeight: FontWeight.w600,
            color: _textColor,
            letterSpacing: imageSize.width * 0.005,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: panelRect.width * 0.8);

      brandTp.paint(
        canvas,
        Offset(
          centerX - brandTp.width / 2,
          centerY - brandTp.height - imageSize.width * 0.01,
        ),
      );
    }

    final dividerWidth = imageSize.width * 0.06;
    final dividerY = centerY;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, dividerY),
        width: dividerWidth,
        height: 1,
      ),
      Paint()..color = _textColor,
    );

    final focalLength = _findValue(fields, 'Focal Length');
    final aperture = _findValue(fields, 'Aperture');
    final shutter = _findValue(fields, 'Shutter');
    final iso = _findValue(fields, 'ISO');

    final metaParts = [
      focalLength,
      aperture,
      shutter,
      iso,
    ].where((s) => s.isNotEmpty).join(' \u2022 ');

    if (metaParts.isNotEmpty) {
      final metaTp = TextPainter(
        text: TextSpan(
          text: metaParts.toUpperCase(),
          style: TextStyle(
            fontSize: imageSize.width * 0.027,
            color: _subtextColor,
            letterSpacing: imageSize.width * 0.003,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: panelRect.width * 0.9);

      metaTp.paint(
        canvas,
        Offset(
          centerX - metaTp.width / 2,
          dividerY + imageSize.width * 0.015,
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
