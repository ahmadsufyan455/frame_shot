import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/export_settings.dart';
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
    final renderData =
        ref.read(frameRenderDataProvider);
    final imageFile =
        ref.read(selectedImageProvider);
    final isPro =
        ref.read(proStatusProvider).value ?? false;

    if (imageFile == null) return;

    state = const ExportState(
      status: ExportStatus.rendering,
    );

    try {
      final bytes = await ExportRenderer.render(
        sourceImagePath: imageFile.path,
        exif: renderData.exif,
        config: renderData.config,
        styleId: renderData.styleId,
        settings: settings,
        isPro: isPro,
      );

      state = ExportState(
        status: ExportStatus.done,
        bytes: bytes,
      );
    } on Exception catch (e) {
      state = ExportState(
        status: ExportStatus.idle,
        error: e.toString(),
      );
    }
  }

  Future<void> saveToGallery(
    ExportSettings settings,
  ) async {
    if (state.bytes == null) {
      await export(settings);
    }
    final bytes = state.bytes;
    if (bytes == null) return;

    state = state.copyWith(
      status: ExportStatus.saving,
    );

    try {
      final ext =
          settings.format == ExportFormat.png
              ? 'png'
              : 'jpg';
      final fileName =
          'frameshot_${DateTime.now().millisecondsSinceEpoch}'
          '.$ext';
      final path = await ShareService.saveToGallery(
        bytes,
        fileName: fileName,
      );
      state = state.copyWith(
        status: ExportStatus.done,
        savedPath: path,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: ExportStatus.idle,
        error: e.toString(),
      );
    }
  }

  Future<void> shareToApp(
    ExportSettings settings,
  ) async {
    if (state.bytes == null) {
      await export(settings);
    }
    final bytes = state.bytes;
    if (bytes == null) return;

    state = state.copyWith(
      status: ExportStatus.sharing,
    );

    try {
      final ext =
          settings.format == ExportFormat.png
              ? 'png'
              : 'jpg';
      final mimeType =
          settings.format == ExportFormat.png
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
      state = state.copyWith(
        status: ExportStatus.done,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: ExportStatus.idle,
        error: e.toString(),
      );
    }
  }

  void reset() => state = const ExportState();
}
