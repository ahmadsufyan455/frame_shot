import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/exif_data.dart';
import 'package:frame_shot/shared/extensions/exif_format_extensions.dart';

void main() {
  group('ExifFormatExtensions', () {
    group('formattedAperture', () {
      test('formats whole number', () {
        const exif = ExifData(aperture: 2.0);
        expect(exif.formattedAperture, 'f/2');
      });

      test('formats decimal', () {
        const exif = ExifData(aperture: 1.8);
        expect(exif.formattedAperture, 'f/1.8');
      });

      test('returns null when null', () {
        expect(const ExifData().formattedAperture, isNull);
      });
    });

    group('formattedShutterSpeed', () {
      test('appends s suffix', () {
        const exif = ExifData(shutterSpeed: '1/500');
        expect(exif.formattedShutterSpeed, '1/500s');
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedShutterSpeed,
          isNull,
        );
      });
    });

    group('formattedIso', () {
      test('formats with ISO prefix', () {
        const exif = ExifData(iso: 800);
        expect(exif.formattedIso, 'ISO 800');
      });

      test('returns null when null', () {
        expect(const ExifData().formattedIso, isNull);
      });
    });

    group('formattedFocalLength', () {
      test('formats without equiv', () {
        const exif = ExifData(focalLength: 35.0);
        expect(exif.formattedFocalLength, '35mm');
      });

      test('formats with equiv', () {
        const exif = ExifData(
          focalLength: 35.0,
          focalLengthEquiv: 52.5,
        );
        expect(
          exif.formattedFocalLength,
          '35mm (53mm equiv.)',
        );
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedFocalLength,
          isNull,
        );
      });
    });

    group('formattedExposureComp', () {
      test('formats positive', () {
        const exif = ExifData(exposureCompensation: 0.3);
        expect(exif.formattedExposureComp, '+0.3 EV');
      });

      test('formats negative', () {
        const exif = ExifData(
          exposureCompensation: -1.0,
        );
        expect(exif.formattedExposureComp, '-1.0 EV');
      });

      test('formats zero', () {
        const exif = ExifData(exposureCompensation: 0.0);
        expect(exif.formattedExposureComp, '±0 EV');
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedExposureComp,
          isNull,
        );
      });
    });

    group('formattedDateTime', () {
      test('formats correctly', () {
        final exif = ExifData(
          dateTime: DateTime(2026, 5, 3, 14, 32),
        );
        expect(
          exif.formattedDateTime,
          '2026-05-03 14:32',
        );
      });

      test('pads single digits', () {
        final exif = ExifData(
          dateTime: DateTime(2026, 1, 5, 8, 3),
        );
        expect(
          exif.formattedDateTime,
          '2026-01-05 08:03',
        );
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedDateTime,
          isNull,
        );
      });
    });

    group('formattedWhiteBalance', () {
      test('returns value as-is', () {
        const exif = ExifData(whiteBalance: 'Auto');
        expect(exif.formattedWhiteBalance, 'Auto');
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedWhiteBalance,
          isNull,
        );
      });
    });

    group('formattedLocation', () {
      test('returns locationName', () {
        const exif = ExifData(
          locationName: 'Jakarta, Indonesia',
        );
        expect(
          exif.formattedLocation,
          'Jakarta, Indonesia',
        );
      });

      test('returns null when null', () {
        expect(
          const ExifData().formattedLocation,
          isNull,
        );
      });
    });
  });
}
