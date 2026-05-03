import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../../shared/extensions/exif_format_extensions.dart';
import '../constants/app_constants.dart';
import '../models/exif_data.dart';
import '../models/frame_config.dart';

abstract class FramePainter extends CustomPainter {
  FramePainter({
    required this.image,
    required this.exif,
    required this.config,
    this.watermark,
  });

  final ui.Image image;
  final ExifData exif;
  final FrameConfig config;
  final ui.Image? watermark;

  Size calculateTotalSize(Size imageSize);

  void paintInfoPanel(Canvas canvas, Rect panelRect);

  void paintPhoto(Canvas canvas, Rect photoRect) {
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    canvas.drawImageRect(image, src, photoRect, Paint());
  }

  void paintWatermark(Canvas canvas, Size totalSize) {
    if (watermark == null) return;
    final logoSize =
        totalSize.width * ImageConstants.watermarkSizeRatio;
    final padding = ImageConstants.watermarkPadding;
    final dst = Rect.fromLTWH(
      totalSize.width - logoSize - padding,
      totalSize.height - logoSize - padding,
      logoSize,
      logoSize,
    );
    canvas.drawImageRect(
      watermark!,
      Rect.fromLTWH(
        0,
        0,
        watermark!.width.toDouble(),
        watermark!.height.toDouble(),
      ),
      dst,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant FramePainter old) {
    return old.config != config ||
        old.exif != exif ||
        old.image != image;
  }

  // -- Shared helpers for subclasses --

  double get frameWeightMultiplier => switch (config.frameWeight) {
        FrameWeight.thin => 0.03,
        FrameWeight.medium => 0.05,
        FrameWeight.thick => 0.08,
      };

  Size get imageSize => Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );

  TextPainter buildTextPainter(
    String text, {
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.left,
    double? maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    )..layout(maxWidth: maxWidth ?? double.infinity);
    return tp;
  }

  List<(String label, String value)> get visibleFields {
    final fields = <(String, String)>[];
    final v = config.visibleFields;
    final o = config.fieldOverrides;

    if (v.camera) {
      final val = o['camera'] ??
          exif.displayCameraName;
      if (val != null) fields.add(('Camera', val));
    }
    if (v.lens) {
      final val = o['lens'] ?? exif.lensModel;
      if (val != null) fields.add(('Lens', val));
    }
    if (v.aperture) {
      final val =
          o['aperture'] ?? exif.formattedAperture;
      if (val != null) fields.add(('Aperture', val));
    }
    if (v.shutterSpeed) {
      final val = o['shutterSpeed'] ??
          exif.formattedShutterSpeed;
      if (val != null) fields.add(('Shutter', val));
    }
    if (v.iso) {
      final val = o['iso'] ?? exif.formattedIso;
      if (val != null) fields.add(('ISO', val));
    }
    if (v.focalLength) {
      final val = o['focalLength'] ??
          exif.formattedFocalLength;
      if (val != null) {
        fields.add(('Focal Length', val));
      }
    }
    if (v.exposureComp) {
      final val = o['exposureComp'] ??
          exif.formattedExposureComp;
      if (val != null) fields.add(('EV', val));
    }
    if (v.whiteBalance) {
      final val = o['whiteBalance'] ??
          exif.formattedWhiteBalance;
      if (val != null) fields.add(('WB', val));
    }
    if (v.dateTime) {
      final val =
          o['dateTime'] ?? exif.formattedDateTime;
      if (val != null) fields.add(('Date', val));
    }
    if (v.location) {
      final val =
          o['location'] ?? exif.formattedLocation;
      if (val != null) fields.add(('Location', val));
    }
    if (v.dimensions) {
      final val = o['dimensions'] ??
          exif.displayDimensions;
      if (val != null) {
        fields.add(('Dimensions', val));
      }
    }
    return fields;
  }
}
