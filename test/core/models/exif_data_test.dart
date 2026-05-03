import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/exif_data.dart';

void main() {
  group('ExifData', () {
    final sampleMap = <String, dynamic>{
      'cameraMake': 'Sony',
      'cameraModel': 'ILCE-7CM2',
      'lensModel': 'FE 35mm F1.8',
      'aperture': 1.8,
      'shutterSpeed': '1/500',
      'iso': 800,
      'focalLength': 35.0,
      'focalLengthEquiv': 52.5,
      'exposureCompensation': 0.3,
      'whiteBalance': 'Auto',
      'dateTime': '2026-05-03T14:32:00.000',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'locationName': 'Jakarta, Indonesia',
      'imageWidth': 7008,
      'imageHeight': 4672,
    };

    test('fromMap/toMap round-trip', () {
      final exif = ExifData.fromMap(sampleMap);
      final map = exif.toMap();
      final restored = ExifData.fromMap(map);

      expect(restored.cameraMake, 'Sony');
      expect(restored.cameraModel, 'ILCE-7CM2');
      expect(restored.lensModel, 'FE 35mm F1.8');
      expect(restored.aperture, 1.8);
      expect(restored.shutterSpeed, '1/500');
      expect(restored.iso, 800);
      expect(restored.focalLength, 35.0);
      expect(restored.focalLengthEquiv, 52.5);
      expect(restored.exposureCompensation, 0.3);
      expect(restored.whiteBalance, 'Auto');
      expect(restored.dateTime, isNotNull);
      expect(restored.latitude, -6.2088);
      expect(restored.longitude, 106.8456);
      expect(
        restored.locationName,
        'Jakarta, Indonesia',
      );
      expect(restored.imageWidth, 7008);
      expect(restored.imageHeight, 4672);
      expect(restored, equals(exif));
    });

    test('isEmpty returns true for empty ExifData', () {
      expect(const ExifData().isEmpty, isTrue);
      expect(ExifData.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false when fields present', () {
      const exif = ExifData(cameraMake: 'Sony');
      expect(exif.isEmpty, isFalse);
    });

    test(
      'displayCameraName avoids duplication',
      () {
        const exif = ExifData(
          cameraMake: 'Sony',
          cameraModel: 'Sony ILCE-7CM2',
        );
        expect(
          exif.displayCameraName,
          'Sony ILCE-7CM2',
        );
      },
    );

    test(
      'displayCameraName combines make and model',
      () {
        const exif = ExifData(
          cameraMake: 'Sony',
          cameraModel: 'ILCE-7CM2',
        );
        expect(
          exif.displayCameraName,
          'Sony ILCE-7CM2',
        );
      },
    );

    test(
      'displayCameraName returns null when both null',
      () {
        expect(const ExifData().displayCameraName, isNull);
      },
    );

    test('displayDimensions formats correctly', () {
      const exif = ExifData(
        imageWidth: 7008,
        imageHeight: 4672,
      );
      expect(exif.displayDimensions, '7008 x 4672');
    });

    test(
      'displayDimensions returns null when partial',
      () {
        const exif = ExifData(imageWidth: 7008);
        expect(exif.displayDimensions, isNull);
      },
    );

    test('copyWith preserves unchanged fields', () {
      final exif = ExifData.fromMap(sampleMap);
      final updated = exif.copyWith(iso: 1600);
      expect(updated.iso, 1600);
      expect(updated.cameraMake, 'Sony');
      expect(updated.aperture, 1.8);
    });

    test('fromMap handles all-null map', () {
      final exif = ExifData.fromMap(
        const <String, dynamic>{},
      );
      expect(exif.isEmpty, isTrue);
      expect(exif.cameraMake, isNull);
    });

    test('equality works', () {
      final a = ExifData.fromMap(sampleMap);
      final b = ExifData.fromMap(sampleMap);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
