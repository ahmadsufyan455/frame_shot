import 'package:flutter/rendering.dart';

import '../frame_painter.dart';

class ClassicPainter extends FramePainter {
  ClassicPainter({
    required super.image,
    required super.exif,
    required super.config,
    super.watermark,
    super.cameraLogo,
  });

  double get _padding =>
      imageSize.width * frameWeightMultiplier;

  double get _infoPanelHeight =>
      imageSize.width * 0.08;

  @override
  Size calculateTotalSize(Size imageSize) {
    final padding =
        imageSize.width * frameWeightMultiplier;
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

    final separatorColor = Color.lerp(
          config.accentColor,
          config.backgroundColor,
          0.5,
        ) ??
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
    if (fields.isEmpty) return;

    final bodySize = imageSize.width * 0.015;
    final inset = imageSize.width * 0.015;
    final logoHeight = _infoPanelHeight * 0.5;

    // -- Left side: camera logo + camera name --
    var leftX = panelRect.left + inset;
    final centerY =
        panelRect.top + (panelRect.height / 2);

    // Paint camera logo if enabled.
    final logoW = cameraLogoWidth(
      maxHeight: logoHeight,
    );
    if (logoW > 0) {
      paintCameraLogo(
        canvas,
        offset: Offset(
          leftX,
          centerY - (logoHeight / 2),
        ),
        maxHeight: logoHeight,
        tintColor: config.textColor,
      );
      leftX += logoW + (inset * 0.5);
    }

    // Camera name on the left.
    final camera = _findValue(fields, 'Camera');
    if (camera.isNotEmpty) {
      final cameraTp = buildTextPainter(
        camera,
        fontSize: bodySize,
        color: config.textColor,
        fontWeight: FontWeight.w600,
        maxWidth: panelRect.width * 0.4,
      );
      cameraTp.paint(
        canvas,
        Offset(leftX, centerY - (cameraTp.height / 2)),
      );
    }

    // -- Right side: all settings joined by pipe --
    final settingLabels = fields
        .where((f) => f.$1 != 'Camera' && f.$1 != 'Date')
        .map((f) => f.$2);
    final settings = settingLabels.join(' | ');

    if (settings.isNotEmpty) {
      final settingsTp = buildTextPainter(
        settings,
        fontSize: bodySize,
        color: config.textColor,
        textAlign: TextAlign.right,
        maxWidth: panelRect.width * 0.55,
      );
      settingsTp.paint(
        canvas,
        Offset(
          panelRect.right - inset - settingsTp.width,
          centerY - (settingsTp.height / 2),
        ),
      );
    }

    // -- Date below settings on the right --
    final date = _findValue(fields, 'Date');
    if (date.isEmpty) return;
    final dateSize = imageSize.width * 0.012;
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
        panelRect.bottom -
            dateTp.height -
            (inset * 0.2),
      ),
    );
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
