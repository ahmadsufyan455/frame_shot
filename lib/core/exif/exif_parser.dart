import 'dart:typed_data';

import 'package:exif/exif.dart' hide ExifData;
import 'package:flutter/foundation.dart'
    show visibleForTesting;

import '../models/exif_data.dart';

@visibleForTesting
abstract final class ExifParserTestHelper {
  static ExifData mapTags(Map<String, IfdTag> tags) =>
      ExifParser._mapTags(tags);
}

abstract final class ExifParser {
  static Future<ExifData> parse(Uint8List bytes) async {
    final tags = await readExifFromBytes(bytes);
    if (tags.isEmpty) return const ExifData();
    return _mapTags(tags);
  }

  static ExifData _mapTags(Map<String, IfdTag> tags) {
    return ExifData(
      cameraMake: _string(tags['Image Make']),
      cameraModel: _string(tags['Image Model']),
      lensModel: _string(tags['EXIF LensModel']) ??
          _string(tags['EXIF LensMake']),
      aperture: _rational(tags['EXIF FNumber']),
      shutterSpeed:
          _shutterSpeed(tags['EXIF ExposureTime']),
      iso: _int(tags['EXIF ISOSpeedRatings']),
      focalLength:
          _rational(tags['EXIF FocalLength']),
      focalLengthEquiv: _rational(
        tags['EXIF FocalLengthIn35mmFilm'],
      ),
      exposureCompensation:
          _rational(tags['EXIF ExposureBiasValue']),
      whiteBalance:
          _whiteBalance(tags['EXIF WhiteBalance']),
      dateTime:
          _dateTime(tags['EXIF DateTimeOriginal']),
      latitude: _coordinate(
        tags['GPS GPSLatitude'],
        tags['GPS GPSLatitudeRef'],
        const ['S'],
      ),
      longitude: _coordinate(
        tags['GPS GPSLongitude'],
        tags['GPS GPSLongitudeRef'],
        const ['W'],
      ),
      imageWidth:
          _int(tags['EXIF ExifImageWidth']) ??
              _int(tags['Image ImageWidth']),
      imageHeight:
          _int(tags['EXIF ExifImageLength']) ??
              _int(tags['Image ImageLength']),
    );
  }

  static String? _string(IfdTag? tag) {
    if (tag == null) return null;
    final value = tag.printable.trim();
    if (value.isEmpty) return null;
    return value;
  }

  static int? _int(IfdTag? tag) {
    if (tag == null) return null;
    final values = tag.values;
    if (values is IfdInts && values.ints.isNotEmpty) {
      return values.ints.first;
    }
    return int.tryParse(tag.printable.trim());
  }

  static double? _rational(IfdTag? tag) {
    if (tag == null) return null;
    final values = tag.values;
    if (values is IfdRatios && values.ratios.isNotEmpty) {
      return values.ratios.first.toDouble();
    }
    return double.tryParse(tag.printable.trim());
  }

  static String? _shutterSpeed(IfdTag? tag) {
    if (tag == null) return null;
    final values = tag.values;
    if (values is IfdRatios && values.ratios.isNotEmpty) {
      final ratio = values.ratios.first;
      final num = ratio.numerator;
      final den = ratio.denominator;
      if (num == 0 || den == 0) return null;
      if (num == 1) return '1/$den';
      if (den == 1) return '$num';
      final seconds = num / den;
      if (seconds < 1) {
        final inverted = (1 / seconds).round();
        return '1/$inverted';
      }
      return seconds.toStringAsFixed(1);
    }
    final printable = tag.printable.trim();
    if (printable.isEmpty) return null;
    return printable;
  }

  static String? _whiteBalance(IfdTag? tag) {
    if (tag == null) return null;
    final printable = tag.printable.trim();
    if (printable.isEmpty) return null;
    if (printable == '0') return 'Auto';
    if (printable == '1') return 'Manual';
    return printable;
  }

  static DateTime? _dateTime(IfdTag? tag) {
    if (tag == null) return null;
    final raw = tag.printable.trim();
    if (raw.isEmpty) return null;
    // EXIF format: "2026:05:03 14:32:00"
    final normalized = raw.replaceFirstMapped(
      RegExp(r'^(\d{4}):(\d{2}):(\d{2})'),
      (m) => '${m[1]}-${m[2]}-${m[3]}',
    );
    return DateTime.tryParse(normalized);
  }

  static double? _coordinate(
    IfdTag? coordTag,
    IfdTag? refTag,
    List<String> negativeRefs,
  ) {
    if (coordTag == null) return null;
    final values = coordTag.values;
    if (values is! IfdRatios) return null;
    final ratios = values.ratios;
    if (ratios.length < 3) return null;

    final degrees = ratios[0].toDouble();
    final minutes = ratios[1].toDouble();
    final seconds = ratios[2].toDouble();

    var coordinate =
        degrees + (minutes / 60.0) + (seconds / 3600.0);

    if (refTag != null) {
      final ref = refTag.printable.trim().toUpperCase();
      if (negativeRefs.contains(ref)) {
        coordinate = -coordinate;
      }
    }

    return coordinate;
  }
}
