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
    polaroid,
    editorial,
  ];

  static const classic = FrameStyle(
    id: FrameStyleId.classic,
    name: 'Classic',
    description:
        'White bottom bar, camera icon left, '
        'metadata right. Clean and minimal.',
    tier: FrameTier.free,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      accentColor: Color(0xFF737373),
    ),
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
      backgroundColor: Color(0xFF000000),
      textColor: Color(0xFF9CA3AF),
      accentColor: Color(0xFF9CA3AF),
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
      textColor: Color(0xFFF2CB05),
      accentColor: Color(0xFFF2CB05),
      fontFamily: FrameFontFamily.mono,
    ),
    thumbnailAsset:
        'assets/thumbnails/film_border.png',
  );

  static const minimalLine = FrameStyle(
    id: FrameStyleId.minimalLine,
    name: 'Minimal Line',
    description:
        'Floating pill overlay with metadata, '
        'inner hairline border, clean white frame.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      accentColor: Color(0x80FFFFFF),
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
        'Grid lines, red viewfinder corners, '
        '4-column HUD data panel.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFF0A0A0A),
      textColor: Color(0xFFEF4444),
      accentColor: Color(0xFFEF4444),
      fontFamily: FrameFontFamily.mono,
    ),
    thumbnailAsset:
        'assets/thumbnails/architect.png',
  );

  static const polaroid = FrameStyle(
    id: FrameStyleId.polaroid,
    name: 'Polaroid',
    description:
        'Instant film aesthetic with slight rotation, '
        'paper texture background, and handwritten feel.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFE2E0DB),
      textColor: Color(0xFF525252),
      accentColor: Color(0xFF737373),
      fontFamily: FrameFontFamily.serif,
    ),
    thumbnailAsset:
        'assets/thumbnails/polaroid.png',
  );

  static const editorial = FrameStyle(
    id: FrameStyleId.editorial,
    name: 'Editorial',
    description:
        'Clean white magazine layout with centered '
        'brand name and minimal metadata strip.',
    tier: FrameTier.pro,
    defaultConfig: FrameConfig(
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      accentColor: Color(0xFF737373),
      fontFamily: FrameFontFamily.serif,
      visibleFields: ExifFieldVisibility(location: true),
    ),
    thumbnailAsset:
        'assets/thumbnails/editorial.png',
  );
}
