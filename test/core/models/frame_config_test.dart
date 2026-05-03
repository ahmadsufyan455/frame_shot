import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/frame_config.dart';

void main() {
  group('ExifFieldVisibility', () {
    test('fromMap/toMap round-trip', () {
      const visibility = ExifFieldVisibility(
        camera: false,
        lens: true,
        aperture: true,
        shutterSpeed: false,
        iso: true,
        focalLength: false,
        exposureComp: true,
        whiteBalance: true,
        dateTime: false,
        location: true,
        dimensions: true,
      );

      final map = visibility.toMap();
      final restored = ExifFieldVisibility.fromMap(map);

      expect(restored.camera, false);
      expect(restored.lens, true);
      expect(restored.aperture, true);
      expect(restored.shutterSpeed, false);
      expect(restored.iso, true);
      expect(restored.focalLength, false);
      expect(restored.exposureComp, true);
      expect(restored.whiteBalance, true);
      expect(restored.dateTime, false);
      expect(restored.location, true);
      expect(restored.dimensions, true);
      expect(restored, equals(visibility));
    });

    test('defaults are correct', () {
      const v = ExifFieldVisibility();
      expect(v.camera, true);
      expect(v.lens, true);
      expect(v.exposureComp, false);
      expect(v.whiteBalance, false);
      expect(v.location, false);
      expect(v.dimensions, false);
    });

    test('fromMap uses defaults for missing keys', () {
      final v = ExifFieldVisibility.fromMap(
        const <String, dynamic>{},
      );
      expect(v.camera, true);
      expect(v.exposureComp, false);
    });
  });

  group('FrameConfig', () {
    test('fromMap/toMap round-trip', () {
      const config = FrameConfig(
        backgroundColor: Color(0xFF000000),
        textColor: Color(0xFFFFFFFF),
        accentColor: Color(0xFF888888),
        fontFamily: FrameFontFamily.mono,
        aspectRatio: AspectRatio.square,
        frameWeight: FrameWeight.thick,
        showCameraLogo: true,
        showLocation: true,
        visibleFields: ExifFieldVisibility(
          camera: false,
          dimensions: true,
        ),
        fieldOverrides: {'camera': 'Custom Camera'},
      );

      final map = config.toMap();
      final restored = FrameConfig.fromMap(map);

      expect(
        restored.backgroundColor,
        const Color(0xFF000000),
      );
      expect(
        restored.textColor,
        const Color(0xFFFFFFFF),
      );
      expect(
        restored.accentColor,
        const Color(0xFF888888),
      );
      expect(restored.fontFamily, FrameFontFamily.mono);
      expect(restored.aspectRatio, AspectRatio.square);
      expect(restored.frameWeight, FrameWeight.thick);
      expect(restored.showCameraLogo, true);
      expect(restored.showLocation, true);
      expect(restored.visibleFields.camera, false);
      expect(restored.visibleFields.dimensions, true);
      expect(
        restored.fieldOverrides['camera'],
        'Custom Camera',
      );
      expect(restored, equals(config));
    });

    test('defaults match TDD spec', () {
      const config = FrameConfig();
      expect(
        config.backgroundColor,
        const Color(0xFFFFFFFF),
      );
      expect(
        config.textColor,
        const Color(0xFF1A1A1A),
      );
      expect(
        config.accentColor,
        const Color(0xFF666666),
      );
      expect(config.fontFamily, FrameFontFamily.sans);
      expect(
        config.aspectRatio,
        AspectRatio.original,
      );
      expect(config.frameWeight, FrameWeight.medium);
      expect(config.showCameraLogo, false);
      expect(config.showLocation, false);
      expect(config.fieldOverrides, isEmpty);
    });

    test('copyWith works for all fields', () {
      const config = FrameConfig();
      final updated = config.copyWith(
        fontFamily: FrameFontFamily.serif,
        showCameraLogo: true,
        fieldOverrides: {'iso': '3200'},
      );
      expect(updated.fontFamily, FrameFontFamily.serif);
      expect(updated.showCameraLogo, true);
      expect(updated.fieldOverrides['iso'], '3200');
      expect(
        updated.backgroundColor,
        const Color(0xFFFFFFFF),
      );
    });

    test('equality and hashCode', () {
      const a = FrameConfig();
      const b = FrameConfig();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));

      final c = a.copyWith(
        fontFamily: FrameFontFamily.mono,
      );
      expect(a, isNot(equals(c)));
    });
  });

  group('Enums', () {
    test('AspectRatio has 4 values', () {
      expect(AspectRatio.values.length, 4);
    });

    test('FrameWeight has 3 values', () {
      expect(FrameWeight.values.length, 3);
    });

    test('FrameFontFamily has 6 values', () {
      expect(FrameFontFamily.values.length, 6);
    });
  });
}
