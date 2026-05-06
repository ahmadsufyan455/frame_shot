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

@Riverpod(keepAlive: true)
class SelectedBatchImages extends _$SelectedBatchImages {
  @override
  List<ImageFile> build() => const [];

  void set(List<ImageFile> images) => state = images;

  void clear() => state = const [];
}

// -- TASK-063: exifExtractionProvider --

@riverpod
class ExifExtraction extends _$ExifExtraction {
  @override
  Future<ExifData?> build() async {
    final image = ref.watch(selectedImageProvider);
    if (image == null) return null;

    final settings = ref.watch(settingsProvider);

    try {
      var exif = await ExifService.extractFromFile(image.path);

      if (!settings.locationEnabled) {
        return exif.stripLocation();
      }

      // Reverse geocode if we have coordinates but no
      // location name.
      if (exif.locationName == null &&
          exif.latitude != null &&
          exif.longitude != null) {
        final name = await GeocodeService.reverseGeocode(
          exif.latitude!,
          exif.longitude!,
        );
        if (name != null) {
          exif = ExifData(
            cameraMake: exif.cameraMake,
            cameraModel: exif.cameraModel,
            lensModel: exif.lensModel,
            aperture: exif.aperture,
            shutterSpeed: exif.shutterSpeed,
            iso: exif.iso,
            focalLength: exif.focalLength,
            focalLengthEquiv: exif.focalLengthEquiv,
            exposureCompensation: exif.exposureCompensation,
            whiteBalance: exif.whiteBalance,
            dateTime: exif.dateTime,
            latitude: exif.latitude,
            longitude: exif.longitude,
            locationName: name,
            imageWidth: exif.imageWidth,
            imageHeight: exif.imageHeight,
          );
        }
      }

      return exif;
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
  return FrameRenderData(exif: exif, config: config, styleId: styleId);
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
