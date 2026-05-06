import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exif/exif_service.dart';
import '../../../core/models/exif_data.dart';
import '../../../core/models/export_settings.dart';
import '../../../core/models/frame_config.dart';
import '../../../core/rendering/export_renderer.dart';
import '../../../core/services/share_service.dart';
import '../../preview/providers/preview_providers.dart';
import '../../settings/providers/settings_providers.dart';

part 'export_providers.g.dart';

// -- TASK-069: exportProvider --

enum ExportStatus { idle, rendering, saving, sharing, done }

class ExportState {
  const ExportState({
    this.status = ExportStatus.idle,
    this.bytes,
    this.savedPath,
    this.error,
  });

  final ExportStatus status;
  final Uint8List? bytes;
  final String? savedPath;
  final String? error;

  ExportState copyWith({
    ExportStatus? status,
    Uint8List? bytes,
    String? savedPath,
    String? error,
  }) {
    return ExportState(
      status: status ?? this.status,
      bytes: bytes ?? this.bytes,
      savedPath: savedPath ?? this.savedPath,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  ExportState build() => const ExportState();

  Future<void> export(ExportSettings settings) async {
    final renderData = ref.read(frameRenderDataProvider);
    final imageFile = ref.read(selectedImageProvider);
    final isPro = ref.read(proStatusProvider).value ?? false;

    if (imageFile == null) return;

    state = const ExportState(status: ExportStatus.rendering);

    try {
      final bytes = await ExportRenderer.render(
        sourceImagePath: imageFile.path,
        exif: renderData.exif,
        config: renderData.config,
        styleId: renderData.styleId,
        settings: settings,
        isPro: isPro,
      );

      state = ExportState(status: ExportStatus.done, bytes: bytes);
    } on Exception catch (e) {
      state = ExportState(status: ExportStatus.idle, error: e.toString());
    }
  }

  Future<void> saveToGallery(ExportSettings settings) async {
    if (state.bytes == null) {
      await export(settings);
    }
    final bytes = state.bytes;
    if (bytes == null) return;

    state = state.copyWith(status: ExportStatus.saving);

    try {
      final ext = settings.format == ExportFormat.png ? 'png' : 'jpg';
      final fileName =
          'frameshot_${DateTime.now().millisecondsSinceEpoch}'
          '.$ext';
      final path = await ShareService.saveToGallery(bytes, fileName: fileName);
      state = state.copyWith(status: ExportStatus.done, savedPath: path);
    } on Exception catch (e) {
      state = state.copyWith(status: ExportStatus.idle, error: e.toString());
    }
  }

  Future<void> shareToApp(ExportSettings settings) async {
    if (state.bytes == null) {
      await export(settings);
    }
    final bytes = state.bytes;
    if (bytes == null) return;

    state = state.copyWith(status: ExportStatus.sharing);

    try {
      final ext = settings.format == ExportFormat.png ? 'png' : 'jpg';
      final mimeType = settings.format == ExportFormat.png
          ? 'image/png'
          : 'image/jpeg';
      final fileName =
          'frameshot_${DateTime.now().millisecondsSinceEpoch}'
          '.$ext';
      await ShareService.shareToApp(
        bytes,
        fileName: fileName,
        mimeType: mimeType,
      );
      state = state.copyWith(status: ExportStatus.done);
    } on Exception catch (e) {
      state = state.copyWith(status: ExportStatus.idle, error: e.toString());
    }
  }

  void reset() => state = const ExportState();
}

enum BatchExportStatus { idle, rendering, saving, done }

class BatchExportState {
  const BatchExportState({
    this.status = BatchExportStatus.idle,
    this.total = 0,
    this.completed = 0,
    this.failed = 0,
    this.currentName,
    this.errors = const [],
  });

  final BatchExportStatus status;
  final int total;
  final int completed;
  final int failed;
  final String? currentName;
  final List<String> errors;

  BatchExportState copyWith({
    BatchExportStatus? status,
    int? total,
    int? completed,
    int? failed,
    String? currentName,
    List<String>? errors,
  }) {
    return BatchExportState(
      status: status ?? this.status,
      total: total ?? this.total,
      completed: completed ?? this.completed,
      failed: failed ?? this.failed,
      currentName: currentName ?? this.currentName,
      errors: errors ?? this.errors,
    );
  }
}

typedef BatchExifExtractor = Future<ExifData> Function(String path);
typedef BatchRenderer =
    Future<Uint8List> Function({
      required String sourceImagePath,
      required ExifData exif,
      required ExportSettings settings,
      required bool isPro,
    });
typedef BatchSaver =
    Future<String> Function(Uint8List bytes, {required String fileName});

@visibleForTesting
FrameConfig batchSanitizedConfig(FrameConfig config) {
  return config.copyWith(fieldOverrides: const {});
}

@visibleForTesting
final batchExifExtractorProvider = Provider<BatchExifExtractor>(
  (ref) => ExifService.extractFromFile,
);

@visibleForTesting
final batchRendererProvider = Provider<BatchRenderer>((ref) {
  return ({
    required String sourceImagePath,
    required ExifData exif,
    required ExportSettings settings,
    required bool isPro,
  }) {
    final renderData = ref.read(frameRenderDataProvider);
    final config = batchSanitizedConfig(renderData.config);
    return ExportRenderer.render(
      sourceImagePath: sourceImagePath,
      exif: exif,
      config: config,
      styleId: renderData.styleId,
      settings: settings,
      isPro: isPro,
    );
  };
});

@visibleForTesting
final batchSaverProvider = Provider<BatchSaver>(
  (ref) => ShareService.saveToGallery,
);

@riverpod
class BatchExportNotifier extends _$BatchExportNotifier {
  @override
  BatchExportState build() => const BatchExportState();

  Future<void> saveBatchToGallery(ExportSettings settings) async {
    final images = ref.read(selectedBatchImagesProvider);
    if (images.length < 2) return;

    final isPro = ref.read(proStatusProvider).value ?? false;
    final appSettings = ref.read(settingsProvider);
    final extractExif = ref.read(batchExifExtractorProvider);
    final render = ref.read(batchRendererProvider);
    final save = ref.read(batchSaverProvider);
    final ext = settings.format == ExportFormat.png ? 'png' : 'jpg';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    state = BatchExportState(
      status: BatchExportStatus.rendering,
      total: images.length,
    );

    var completed = 0;
    var failed = 0;
    final errors = <String>[];

    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      state = state.copyWith(
        status: BatchExportStatus.rendering,
        currentName: image.name,
        completed: completed,
        failed: failed,
      );

      try {
        var exif = await extractExif(image.path);
        if (!appSettings.locationEnabled) {
          exif = exif.stripLocation();
        }

        final bytes = await render(
          sourceImagePath: image.path,
          exif: exif,
          settings: settings,
          isPro: isPro,
        );

        state = state.copyWith(status: BatchExportStatus.saving);
        final fileName = 'frameshot_batch_${timestamp}_${i + 1}.$ext';
        await save(bytes, fileName: fileName);
        completed++;
      } on Exception catch (e) {
        failed++;
        errors.add('${image.name}: $e');
      }

      state = state.copyWith(
        completed: completed,
        failed: failed,
        errors: List.unmodifiable(errors),
      );
    }

    state = state.copyWith(status: BatchExportStatus.done, currentName: null);
  }

  void reset() => state = const BatchExportState();
}
