import 'dart:io';
import 'dart:ui' as ui;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/exif/exif_service.dart';
import '../../../core/exif/geocode_service.dart';
import '../../../core/models/exif_data.dart';
import '../../../core/models/frame_config.dart';
import '../../../core/models/frame_style.dart';
import '../../../core/models/image_file.dart';
import '../../customize/providers/customize_providers.dart';
import '../../settings/providers/settings_providers.dart';
import 'style_providers.dart';

part 'preview_providers.g.dart';

// -- TASK-062: selectedImageProvider --

@Riverpod(keepAlive: true)
class SelectedImage extends _$SelectedImage {
  @override
  ImageFile? build() => null;

  void set(ImageFile? image) => state = image;

  void clear() => state = null;
}

// -- TASK-063: exifExtractionProvider --

@riverpod
class ExifExtraction extends _$ExifExtraction {
  @override
  Future<ExifData?> build() async {
    final image = ref.watch(selectedImageProvider);
    if (image == null) return null;
    try {
      return await ExifService.extractFromFile(
        image.path,
      );
    } on Exception {
      return ExifData.empty;
    }
  }
}

// -- TASK-067: frameRenderDataProvider --

class FrameRenderData {
  const FrameRenderData({
    required this.exif,
    required this.config,
    required this.styleId,
  });

  final ExifData exif;
  final FrameConfig config;
  final FrameStyleId styleId;
}

@riverpod
FrameRenderData frameRenderData(Ref ref) {
  final exif = ref.watch(editedExifProvider);
  final config = ref.watch(frameConfigProvider);
  final styleId = ref.watch(selectedStyleProvider);
  return FrameRenderData(
    exif: exif,
    config: config,
    styleId: styleId,
  );
}

// -- TASK-068: previewImageProvider --

@riverpod
Future<ui.Image?> previewImage(Ref ref) async {
  final imageFile = ref.watch(selectedImageProvider);
  if (imageFile == null) return null;

  final file = File(imageFile.path);
  if (!file.existsSync()) return null;

  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: ImageConstants.previewMaxDimension,
  );
  final frame = await codec.getNextFrame();
  return frame.image;
}

// -- TASK-070: locationPermissionProvider --

@riverpod
bool locationPermission(Ref ref) {
  final settings = ref.watch(settingsProvider);
  return settings.locationEnabled;
}

// -- TASK-070: reverseGeocodeProvider --

@riverpod
Future<String?> reverseGeocode(
  Ref ref,
  double latitude,
  double longitude,
) async {
  return GeocodeService.reverseGeocode(
    latitude,
    longitude,
  );
}
