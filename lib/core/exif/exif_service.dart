import 'dart:io';
import 'dart:isolate';

import '../models/exif_data.dart';
import 'exif_parser.dart';
import 'native_exif_fallback.dart';

abstract final class ExifService {
  static Future<ExifData> extractFromFile(
    String filePath,
  ) async {
    final bytes = await File(filePath).readAsBytes();

    final primary = await Isolate.run(
      () => ExifParser.parse(bytes),
    );

    if (_isInsufficient(primary)) {
      final fallback =
          await NativeExifFallback.extract(filePath);
      return _merge(primary, fallback);
    }

    return primary;
  }

  static bool _isInsufficient(ExifData data) {
    return data.cameraMake == null &&
        data.cameraModel == null;
  }

  /// Merges primary and fallback, preferring primary
  /// values when non-null.
  static ExifData _merge(
    ExifData primary,
    ExifData fallback,
  ) {
    return ExifData(
      cameraMake:
          primary.cameraMake ?? fallback.cameraMake,
      cameraModel:
          primary.cameraModel ?? fallback.cameraModel,
      lensModel:
          primary.lensModel ?? fallback.lensModel,
      aperture:
          primary.aperture ?? fallback.aperture,
      shutterSpeed:
          primary.shutterSpeed ?? fallback.shutterSpeed,
      iso: primary.iso ?? fallback.iso,
      focalLength:
          primary.focalLength ?? fallback.focalLength,
      focalLengthEquiv: primary.focalLengthEquiv ??
          fallback.focalLengthEquiv,
      exposureCompensation:
          primary.exposureCompensation ??
              fallback.exposureCompensation,
      whiteBalance:
          primary.whiteBalance ?? fallback.whiteBalance,
      dateTime:
          primary.dateTime ?? fallback.dateTime,
      latitude:
          primary.latitude ?? fallback.latitude,
      longitude:
          primary.longitude ?? fallback.longitude,
      locationName: primary.locationName ??
          fallback.locationName,
      imageWidth:
          primary.imageWidth ?? fallback.imageWidth,
      imageHeight:
          primary.imageHeight ?? fallback.imageHeight,
    );
  }
}
