import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/frame_config.dart';
import 'package:frame_shot/core/models/frame_style.dart';

void main() {
  group('FrameStyle', () {
    test('isFree returns true for free tier', () {
      const style = FrameStyle(
        id: FrameStyleId.classic,
        name: 'Classic',
        description: 'White bottom bar, clean layout.',
        tier: FrameTier.free,
        defaultConfig: FrameConfig(),
        thumbnailAsset: 'assets/thumbnails/classic.png',
      );
      expect(style.isFree, true);
      expect(style.isPro, false);
    });

    test('isPro returns true for pro tier', () {
      const style = FrameStyle(
        id: FrameStyleId.darkroom,
        name: 'Darkroom',
        description: 'Dark background, moody aesthetic.',
        tier: FrameTier.pro,
        defaultConfig: FrameConfig(),
        thumbnailAsset:
            'assets/thumbnails/darkroom.png',
      );
      expect(style.isFree, false);
      expect(style.isPro, true);
    });

    test('FrameStyleId has 6 values', () {
      expect(FrameStyleId.values.length, 6);
      expect(
        FrameStyleId.values,
        containsAll([
          FrameStyleId.classic,
          FrameStyleId.darkroom,
          FrameStyleId.filmBorder,
          FrameStyleId.minimalLine,
          FrameStyleId.fujifilmSim,
          FrameStyleId.architect,
        ]),
      );
    });

    test('FrameTier has 2 values', () {
      expect(FrameTier.values.length, 2);
    });

    test('equality by id', () {
      const a = FrameStyle(
        id: FrameStyleId.classic,
        name: 'Classic',
        description: 'Desc A',
        tier: FrameTier.free,
        defaultConfig: FrameConfig(),
        thumbnailAsset: 'a.png',
      );
      const b = FrameStyle(
        id: FrameStyleId.classic,
        name: 'Classic v2',
        description: 'Desc B',
        tier: FrameTier.free,
        defaultConfig: FrameConfig(),
        thumbnailAsset: 'b.png',
      );
      expect(a, equals(b));
    });
  });
}
