import 'package:native_exif/native_exif.dart';

import '../models/exif_data.dart';

abstract final class NativeExifFallback {
  static Future<ExifData> extract(String filePath) async {
    Exif? exif;
    try {
      exif = await Exif.fromPath(filePath);

      final date = await exif.getOriginalDate();
      final gps = await exif.getLatLong();

      final make = await _attr(exif, 'Make');
      final model = await _attr(exif, 'Model');
      final lens = await _attr(exif, 'LensModel');
      final apertureRaw = await _attr(exif, 'FNumber');
      final isoRaw =
          await _attr(exif, 'ISOSpeedRatings');
      final shutterRaw =
          await _attr(exif, 'ExposureTime');
      final focalRaw =
          await _attr(exif, 'FocalLength');
      final focalEquivRaw =
          await _attr(exif, 'FocalLengthIn35mmFilm');
      final exposureCompRaw =
          await _attr(exif, 'ExposureBiasValue');
      final widthRaw =
          await _attr(exif, 'ImageWidth');
      final heightRaw =
          await _attr(exif, 'ImageLength');

      return ExifData(
        cameraMake: make,
        cameraModel: model,
        lensModel: lens,
        aperture: _parseDouble(apertureRaw),
        shutterSpeed: _parseShutter(shutterRaw),
        iso: _parseInt(isoRaw),
        focalLength: _parseDouble(focalRaw),
        focalLengthEquiv: _parseDouble(focalEquivRaw),
        exposureCompensation:
            _parseDouble(exposureCompRaw),
        dateTime: date,
        latitude: gps?.latitude,
        longitude: gps?.longitude,
        imageWidth: _parseInt(widthRaw),
        imageHeight: _parseInt(heightRaw),
      );
    } on Exception {
      return const ExifData();
    } finally {
      await exif?.close();
    }
  }

  static Future<String?> _attr(
    Exif exif,
    String tag,
  ) async {
    try {
      final value =
          await exif.getAttribute<Object>(tag);
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      return str;
    } on Exception {
      return null;
    }
  }

  static double? _parseDouble(String? value) {
    if (value == null) return null;
    // Handle rational format "n/d"
    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        final num = double.tryParse(parts[0]);
        final den = double.tryParse(parts[1]);
        if (num != null && den != null && den != 0) {
          return num / den;
        }
      }
    }
    return double.tryParse(value);
  }

  static int? _parseInt(String? value) {
    if (value == null) return null;
    return int.tryParse(value);
  }

  static String? _parseShutter(String? value) {
    if (value == null) return null;
    // Already a fraction like "1/500"
    if (value.contains('/')) return value;
    final seconds = double.tryParse(value);
    if (seconds == null) return value;
    if (seconds >= 1) {
      return seconds.toStringAsFixed(1);
    }
    final inverted = (1 / seconds).round();
    return '1/$inverted';
  }
}
