import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/exif_data.dart';
import '../../../core/models/frame_config.dart';
import '../../preview/providers/preview_providers.dart';
import '../../preview/providers/style_providers.dart';

part 'customize_providers.g.dart';

// -- TASK-064: editedExifProvider --

@riverpod
class EditedExif extends _$EditedExif {
  @override
  ExifData build() {
    final asyncExif = ref.watch(exifExtractionProvider);
    return asyncExif.whenOrNull(data: (d) => d) ??
        ExifData.empty;
  }

  void update(ExifData exif) => state = exif;

  void updateField(String field, String value) {
    switch (field) {
      case 'cameraMake':
        state = state.copyWith(cameraMake: value);
      case 'cameraModel':
        state = state.copyWith(cameraModel: value);
      case 'lensModel':
        state = state.copyWith(lensModel: value);
      case 'shutterSpeed':
        state = state.copyWith(shutterSpeed: value);
      case 'whiteBalance':
        state = state.copyWith(whiteBalance: value);
      case 'locationName':
        state = state.copyWith(locationName: value);
    }
  }

  void reset() {
    ref.invalidateSelf();
  }
}

// -- TASK-066: frameConfigProvider --

@riverpod
class FrameConfigNotifier extends _$FrameConfigNotifier {
  @override
  FrameConfig build() {
    final styleId = ref.watch(selectedStyleProvider);
    final styles = ref.watch(frameStylesProvider);
    final style =
        styles.firstWhere((s) => s.id == styleId);
    return style.defaultConfig;
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
  }

  void updateTextColor(Color color) {
    state = state.copyWith(textColor: color);
  }

  void updateAccentColor(Color color) {
    state = state.copyWith(accentColor: color);
  }

  void setFont(FrameFontFamily font) {
    state = state.copyWith(fontFamily: font);
  }

  void setAspectRatio(AspectRatio ratio) {
    state = state.copyWith(aspectRatio: ratio);
  }

  void setFrameWeight(FrameWeight weight) {
    state = state.copyWith(frameWeight: weight);
  }

  void toggleCameraLogo(bool show) {
    state = state.copyWith(showCameraLogo: show);
  }

  void toggleLocation(bool show) {
    state = state.copyWith(showLocation: show);
  }

  void toggleField(String field, bool visible) {
    final current = state.visibleFields;
    final updated = switch (field) {
      'camera' =>
        current.copyWith(camera: visible),
      'lens' => current.copyWith(lens: visible),
      'aperture' =>
        current.copyWith(aperture: visible),
      'shutterSpeed' =>
        current.copyWith(shutterSpeed: visible),
      'iso' => current.copyWith(iso: visible),
      'focalLength' =>
        current.copyWith(focalLength: visible),
      'exposureComp' =>
        current.copyWith(exposureComp: visible),
      'whiteBalance' =>
        current.copyWith(whiteBalance: visible),
      'dateTime' =>
        current.copyWith(dateTime: visible),
      'location' =>
        current.copyWith(location: visible),
      'dimensions' =>
        current.copyWith(dimensions: visible),
      _ => current,
    };
    state = state.copyWith(visibleFields: updated);
  }

  void setFieldOverride(String field, String value) {
    final overrides =
        Map<String, String>.from(state.fieldOverrides);
    if (value.isEmpty) {
      overrides.remove(field);
    } else {
      overrides[field] = value;
    }
    state = state.copyWith(fieldOverrides: overrides);
  }
}
