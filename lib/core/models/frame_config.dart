import 'dart:ui';

import '../../shared/extensions/color_extensions.dart';

enum AspectRatio {
  original,
  square,
  fourFive,
  threeFour,
  sixteenNine,
  nineSixteen,
}

enum FrameWeight { thin, medium, thick }

enum FrameFontFamily { serif, sans, mono, displayA, displayB, handwritten }

class ExifFieldVisibility {
  const ExifFieldVisibility({
    // Primary fields — user-controlled toggles.
    this.camera = true,
    this.lens = true,
    this.dateTime = true,
    this.location = false,
    // Secondary fields — always enabled; each frame
    // style decides which to render in its layout.
    this.aperture = true,
    this.shutterSpeed = true,
    this.iso = true,
    this.focalLength = true,
    this.exposureComp = true,
    this.whiteBalance = true,
    this.dimensions = true,
  });

  factory ExifFieldVisibility.fromMap(Map<String, dynamic> map) {
    return ExifFieldVisibility(
      camera: map['camera'] as bool? ?? true,
      lens: map['lens'] as bool? ?? true,
      aperture: map['aperture'] as bool? ?? true,
      shutterSpeed: map['shutterSpeed'] as bool? ?? true,
      iso: map['iso'] as bool? ?? true,
      focalLength: map['focalLength'] as bool? ?? true,
      exposureComp: map['exposureComp'] as bool? ?? false,
      whiteBalance: map['whiteBalance'] as bool? ?? false,
      dateTime: map['dateTime'] as bool? ?? true,
      location: map['location'] as bool? ?? false,
      dimensions: map['dimensions'] as bool? ?? false,
    );
  }

  final bool camera;
  final bool lens;
  final bool aperture;
  final bool shutterSpeed;
  final bool iso;
  final bool focalLength;
  final bool exposureComp;
  final bool whiteBalance;
  final bool dateTime;
  final bool location;
  final bool dimensions;

  ExifFieldVisibility copyWith({
    bool? camera,
    bool? lens,
    bool? aperture,
    bool? shutterSpeed,
    bool? iso,
    bool? focalLength,
    bool? exposureComp,
    bool? whiteBalance,
    bool? dateTime,
    bool? location,
    bool? dimensions,
  }) {
    return ExifFieldVisibility(
      camera: camera ?? this.camera,
      lens: lens ?? this.lens,
      aperture: aperture ?? this.aperture,
      shutterSpeed: shutterSpeed ?? this.shutterSpeed,
      iso: iso ?? this.iso,
      focalLength: focalLength ?? this.focalLength,
      exposureComp: exposureComp ?? this.exposureComp,
      whiteBalance: whiteBalance ?? this.whiteBalance,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      dimensions: dimensions ?? this.dimensions,
    );
  }

  Map<String, dynamic> toMap() => {
    'camera': camera,
    'lens': lens,
    'aperture': aperture,
    'shutterSpeed': shutterSpeed,
    'iso': iso,
    'focalLength': focalLength,
    'exposureComp': exposureComp,
    'whiteBalance': whiteBalance,
    'dateTime': dateTime,
    'location': location,
    'dimensions': dimensions,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExifFieldVisibility &&
        other.camera == camera &&
        other.lens == lens &&
        other.aperture == aperture &&
        other.shutterSpeed == shutterSpeed &&
        other.iso == iso &&
        other.focalLength == focalLength &&
        other.exposureComp == exposureComp &&
        other.whiteBalance == whiteBalance &&
        other.dateTime == dateTime &&
        other.location == location &&
        other.dimensions == dimensions;
  }

  @override
  int get hashCode => Object.hash(
    camera,
    lens,
    aperture,
    shutterSpeed,
    iso,
    focalLength,
    exposureComp,
    whiteBalance,
    dateTime,
    location,
    dimensions,
  );
}

class FrameConfig {
  const FrameConfig({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF1A1A1A),
    this.accentColor = const Color(0xFF666666),
    this.fontFamily = FrameFontFamily.sans,
    this.aspectRatio = AspectRatio.square,
    this.frameWeight = FrameWeight.medium,
    this.showCameraLogo = false,
    this.showLocation = false,
    this.visibleFields = const ExifFieldVisibility(),
    this.fieldOverrides = const {},
  });

  factory FrameConfig.fromMap(Map<String, dynamic> map) {
    return FrameConfig(
      backgroundColor: colorFromArgbInt(map['backgroundColor'] as int),
      textColor: colorFromArgbInt(map['textColor'] as int),
      accentColor: colorFromArgbInt(map['accentColor'] as int),
      fontFamily: FrameFontFamily.values.byName(map['fontFamily'] as String),
      aspectRatio: AspectRatio.values.byName(map['aspectRatio'] as String),
      frameWeight: FrameWeight.values.byName(map['frameWeight'] as String),
      showCameraLogo: map['showCameraLogo'] as bool,
      showLocation: map['showLocation'] as bool,
      visibleFields: ExifFieldVisibility.fromMap(
        map['visibleFields'] as Map<String, dynamic>,
      ),
      fieldOverrides: Map<String, String>.from(map['fieldOverrides'] as Map),
    );
  }

  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final FrameFontFamily fontFamily;
  final AspectRatio aspectRatio;
  final FrameWeight frameWeight;
  final bool showCameraLogo;
  final bool showLocation;
  final ExifFieldVisibility visibleFields;
  final Map<String, String> fieldOverrides;

  FrameConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? accentColor,
    FrameFontFamily? fontFamily,
    AspectRatio? aspectRatio,
    FrameWeight? frameWeight,
    bool? showCameraLogo,
    bool? showLocation,
    ExifFieldVisibility? visibleFields,
    Map<String, String>? fieldOverrides,
  }) {
    return FrameConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      fontFamily: fontFamily ?? this.fontFamily,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      frameWeight: frameWeight ?? this.frameWeight,
      showCameraLogo: showCameraLogo ?? this.showCameraLogo,
      showLocation: showLocation ?? this.showLocation,
      visibleFields: visibleFields ?? this.visibleFields,
      fieldOverrides: fieldOverrides ?? this.fieldOverrides,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'backgroundColor': backgroundColor.toArgbInt(),
      'textColor': textColor.toArgbInt(),
      'accentColor': accentColor.toArgbInt(),
      'fontFamily': fontFamily.name,
      'aspectRatio': aspectRatio.name,
      'frameWeight': frameWeight.name,
      'showCameraLogo': showCameraLogo,
      'showLocation': showLocation,
      'visibleFields': visibleFields.toMap(),
      'fieldOverrides': fieldOverrides,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FrameConfig) return false;
    if (other.backgroundColor != backgroundColor ||
        other.textColor != textColor ||
        other.accentColor != accentColor ||
        other.fontFamily != fontFamily ||
        other.aspectRatio != aspectRatio ||
        other.frameWeight != frameWeight ||
        other.showCameraLogo != showCameraLogo ||
        other.showLocation != showLocation ||
        other.visibleFields != visibleFields) {
      return false;
    }
    if (other.fieldOverrides.length != fieldOverrides.length) {
      return false;
    }
    for (final entry in fieldOverrides.entries) {
      if (other.fieldOverrides[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    textColor,
    accentColor,
    fontFamily,
    aspectRatio,
    frameWeight,
    showCameraLogo,
    showLocation,
    visibleFields,
    Object.hashAll(
      fieldOverrides.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}
