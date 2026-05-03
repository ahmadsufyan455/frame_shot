import 'dart:ui';

import '../models/frame_config.dart';
import '../models/frame_style.dart';

abstract final class FrameStyles {
  static const List<FrameStyle> all = [
    classic,
    darkroom,
    filmBorder,
    minimalLine,
    fujifilmSim,
    architect,
  ];

  static const classic = FrameStyle(
    id: FrameStyleId.classic,
    name: 'Classic',
    description:
        'White bottom bar, camera icon left, '
        'metadata right. Clean and minimal.',
    tier: FrameTier.free,
    defaultConfig: FrameConfig(),
    thumbnailAsset:
        'assets/thumbnails/classic.png',
  );

  static const darkroom = FrameStyle(
    id: FrameStyleId.darkroom,
    name: 'Darkroom',
    description:
        'Full black frame, monospace font, '
        'film-inspired layout.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFF0A0A0A),
      textColor: Color(0xFFE0E0E0),
      accentColor: Color(0xFF888888),
      fontFamily: FrameFontFamily.mono,
    ),
    thumbnailAsset:
        'assets/thumbnails/darkroom.png',
  );

  static const filmBorder = FrameStyle(
    id: FrameStyleId.filmBorder,
    name: 'Film Border',
    description:
        'Sprocket hole decorations on sides, '
        'film grain overlay, Kodak-style typography.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFF1A1A1A),
      textColor: Color(0xFFF5E6C8),
      accentColor: Color(0xFFD4A853),
      fontFamily: FrameFontFamily.serif,
    ),
    thumbnailAsset:
        'assets/thumbnails/film_border.png',
  );

  static const minimalLine = FrameStyle(
    id: FrameStyleId.minimalLine,
    name: 'Minimal Line',
    description:
        'Single hairline border, bottom-center '
        'metadata strip, no icons.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFFAFAFA),
      textColor: Color(0xFF333333),
      accentColor: Color(0xFFAAAAAA),
      fontFamily: FrameFontFamily.sans,
      frameWeight: FrameWeight.thin,
    ),
    thumbnailAsset:
        'assets/thumbnails/minimal_line.png',
  );

  static const fujifilmSim = FrameStyle(
    id: FrameStyleId.fujifilmSim,
    name: 'Fujifilm Sim',
    description:
        'Teal/cream palette, square crop option, '
        'mimics Fuji print aesthetic.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFF5F0E8),
      textColor: Color(0xFF2D4A3E),
      accentColor: Color(0xFF5B8A72),
      fontFamily: FrameFontFamily.serif,
      aspectRatio: AspectRatio.square,
    ),
    thumbnailAsset:
        'assets/thumbnails/fujifilm_sim.png',
  );

  static const architect = FrameStyle(
    id: FrameStyleId.architect,
    name: 'Architect',
    description:
        'Grid lines, technical-looking data layout, '
        'inspired by camera viewfinder overlays.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFF1E2A38),
      textColor: Color(0xFF00E5FF),
      accentColor: Color(0xFF4DD0E1),
      fontFamily: FrameFontFamily.mono,
    ),
    thumbnailAsset:
        'assets/thumbnails/architect.png',
  );
}
