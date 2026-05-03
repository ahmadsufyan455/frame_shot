import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/frame_config.dart';
import 'package:frame_shot/core/models/frame_style.dart';
import 'package:frame_shot/core/models/user_preset.dart';

void main() {
  group('UserPreset', () {
    final samplePreset = UserPreset(
      id: 'abc-123',
      name: 'My Preset',
      styleId: FrameStyleId.darkroom,
      config: const FrameConfig(
        backgroundColor: Color(0xFF000000),
        fontFamily: FrameFontFamily.mono,
        showCameraLogo: true,
      ),
      createdAt: DateTime.utc(2026, 5, 3, 14, 32),
    );

    test('fromMap/toMap round-trip', () {
      final map = samplePreset.toMap();
      final restored = UserPreset.fromMap(map);

      expect(restored.id, 'abc-123');
      expect(restored.name, 'My Preset');
      expect(
        restored.styleId,
        FrameStyleId.darkroom,
      );
      expect(
        restored.config.backgroundColor,
        const Color(0xFF000000),
      );
      expect(
        restored.config.fontFamily,
        FrameFontFamily.mono,
      );
      expect(restored.config.showCameraLogo, true);
      expect(
        restored.createdAt,
        DateTime.utc(2026, 5, 3, 14, 32),
      );
    });

    test('equality by id', () {
      final other = samplePreset.copyWith(
        name: 'Different Name',
      );
      expect(samplePreset, equals(other));
    });

    test('copyWith works', () {
      final updated = samplePreset.copyWith(
        name: 'Updated',
        styleId: FrameStyleId.classic,
      );
      expect(updated.name, 'Updated');
      expect(updated.styleId, FrameStyleId.classic);
      expect(updated.id, 'abc-123');
    });
  });
}
