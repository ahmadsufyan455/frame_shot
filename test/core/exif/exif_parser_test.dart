import 'dart:typed_data';

import 'package:exif/exif.dart' hide ExifData;
import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/exif/exif_parser.dart';
import 'package:frame_shot/core/models/exif_data.dart';

void main() {
  group('ExifParser', () {
    test(
      'parse returns empty for minimal JPEG',
      () async {
        final ExifData result = await ExifParser.parse(
          Uint8List.fromList(
            [0xFF, 0xD8, 0xFF, 0xD9],
          ),
        );
        expect(result.isEmpty, isTrue);
      },
    );

    test('mapTags extracts all fields', () {
      final tags = _buildMockTags();
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);

      expect(result.cameraMake, 'Sony');
      expect(result.cameraModel, 'ILCE-7CM2');
      expect(result.lensModel, 'FE 35mm F1.8');
      expect(result.aperture, 1.8);
      expect(result.shutterSpeed, '1/500');
      expect(result.iso, 800);
      expect(result.focalLength, 35.0);
      expect(result.focalLengthEquiv, 52.0);
      expect(
        result.exposureCompensation,
        closeTo(0.3, 0.01),
      );
      expect(result.whiteBalance, 'Auto');
      expect(result.imageWidth, 7008);
      expect(result.imageHeight, 4672);
      expect(
        result.latitude,
        closeTo(-6.2088, 0.001),
      );
      expect(
        result.longitude,
        closeTo(106.8456, 0.001),
      );
    });

    test('mapTags handles missing tags', () {
      final ExifData result =
          ExifParserTestHelper.mapTags({});
      expect(result.isEmpty, isTrue);
      expect(result.cameraMake, isNull);
      expect(result.aperture, isNull);
    });

    test('shutterSpeed formats fraction', () {
      final tags = <String, IfdTag>{
        'EXIF ExposureTime': _ratioTag(1, 2000),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.shutterSpeed, '1/2000');
    });

    test('shutterSpeed handles long exposure', () {
      final tags = <String, IfdTag>{
        'EXIF ExposureTime': _ratioTag(30, 1),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.shutterSpeed, '30');
    });

    test('whiteBalance maps 0 to Auto', () {
      final tags = <String, IfdTag>{
        'EXIF WhiteBalance': _stringTag('0'),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.whiteBalance, 'Auto');
    });

    test('whiteBalance maps 1 to Manual', () {
      final tags = <String, IfdTag>{
        'EXIF WhiteBalance': _stringTag('1'),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.whiteBalance, 'Manual');
    });

    test('dateTime parses EXIF format', () {
      final tags = <String, IfdTag>{
        'EXIF DateTimeOriginal': _stringTag(
          '2026:05:03 14:32:00',
        ),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.dateTime, isNotNull);
      expect(result.dateTime!.year, 2026);
      expect(result.dateTime!.month, 5);
      expect(result.dateTime!.day, 3);
      expect(result.dateTime!.hour, 14);
      expect(result.dateTime!.minute, 32);
    });

    test('GPS south produces negative latitude', () {
      final tags = <String, IfdTag>{
        'GPS GPSLatitude': _gpsTag(6, 12, 31.68),
        'GPS GPSLatitudeRef': _stringTag('S'),
        'GPS GPSLongitude': _gpsTag(106, 50, 44.16),
        'GPS GPSLongitudeRef': _stringTag('E'),
      };
      final ExifData result =
          ExifParserTestHelper.mapTags(tags);
      expect(result.latitude! < 0, isTrue);
      expect(result.longitude! > 0, isTrue);
    });
  });
}

Map<String, IfdTag> _buildMockTags() {
  return {
    'Image Make': _stringTag('Sony'),
    'Image Model': _stringTag('ILCE-7CM2'),
    'EXIF LensModel': _stringTag('FE 35mm F1.8'),
    'EXIF FNumber': _ratioTag(9, 5),
    'EXIF ExposureTime': _ratioTag(1, 500),
    'EXIF ISOSpeedRatings': _intTag(800),
    'EXIF FocalLength': _ratioTag(35, 1),
    'EXIF FocalLengthIn35mmFilm': _ratioTag(52, 1),
    'EXIF ExposureBiasValue': _ratioTag(3, 10),
    'EXIF WhiteBalance': _stringTag('0'),
    'EXIF DateTimeOriginal': _stringTag(
      '2026:05:03 14:32:00',
    ),
    'EXIF ExifImageWidth': _intTag(7008),
    'EXIF ExifImageLength': _intTag(4672),
    'GPS GPSLatitude': _gpsTag(6, 12, 31.68),
    'GPS GPSLatitudeRef': _stringTag('S'),
    'GPS GPSLongitude': _gpsTag(106, 50, 44.16),
    'GPS GPSLongitudeRef': _stringTag('E'),
  };
}

IfdTag _stringTag(String value) => IfdTag(
      tag: 0,
      tagType: 'ASCII',
      printable: value,
      values: const IfdNone(),
    );

IfdTag _intTag(int value) => IfdTag(
      tag: 0,
      tagType: 'Short',
      printable: '$value',
      values: IfdInts([value]),
    );

IfdTag _ratioTag(int num, int den) => IfdTag(
      tag: 0,
      tagType: 'Ratio',
      printable: '$num/$den',
      values: IfdRatios([Ratio(num, den)]),
    );

IfdTag _gpsTag(
  double degrees,
  double minutes,
  double seconds,
) {
  return IfdTag(
    tag: 0,
    tagType: 'Ratio',
    printable: '',
    values: IfdRatios([
      Ratio(
        (degrees * 1000000).round(),
        1000000,
      ),
      Ratio(
        (minutes * 1000000).round(),
        1000000,
      ),
      Ratio(
        (seconds * 1000000).round(),
        1000000,
      ),
    ]),
  );
}
