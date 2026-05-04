import 'frame_config.dart';

enum FrameStyleId {
  classic,
  darkroom,
  filmBorder,
  minimalLine,
  fujifilmSim,
  architect,
  polaroid,
  editorial,
}

enum FrameTier { free, pro }

class FrameStyle {
  const FrameStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.defaultConfig,
    required this.thumbnailAsset,
  });

  final FrameStyleId id;
  final String name;
  final String description;
  final FrameTier tier;
  final FrameConfig defaultConfig;
  final String thumbnailAsset;

  bool get isFree => tier == FrameTier.free;
  bool get isPro => tier == FrameTier.pro;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrameStyle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
