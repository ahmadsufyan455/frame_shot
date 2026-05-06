import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/exif_data.dart';
import 'package:frame_shot/core/models/export_settings.dart';
import 'package:frame_shot/core/models/frame_config.dart';
import 'package:frame_shot/core/models/frame_style.dart';
import 'package:frame_shot/core/models/image_file.dart';
import 'package:frame_shot/features/export/providers/export_providers.dart';
import 'package:frame_shot/features/preview/providers/preview_providers.dart';
import 'package:frame_shot/features/settings/providers/settings_providers.dart';

void main() {
  group('batchSanitizedConfig', () {
    test('clears manual field overrides', () {
      const config = FrameConfig(fieldOverrides: {'camera': 'manual-camera'});

      final sanitized = batchSanitizedConfig(config);
      expect(sanitized.fieldOverrides, isEmpty);
    });
  });

  group('BatchExportNotifier', () {
    test('no-op for empty or single selection', () async {
      final container = ProviderContainer(
        overrides: [selectedBatchImagesProvider.overrideWithValue(const [])],
      );
      addTearDown(container.dispose);

      await container
          .read(batchExportProvider.notifier)
          .saveBatchToGallery(const ExportSettings());

      expect(
        container.read(batchExportProvider).status,
        BatchExportStatus.idle,
      );
    });

    test('continues after one item fails and reports counts', () async {
      final images = [
        const ImageFile(path: '/tmp/a.jpg', name: 'a.jpg', sizeBytes: 1),
        const ImageFile(path: '/tmp/b.jpg', name: 'b.jpg', sizeBytes: 1),
      ];

      var renderCalls = 0;
      var saveCalls = 0;

      final container = ProviderContainer(
        overrides: [
          selectedBatchImagesProvider.overrideWithValue(images),
          settingsProvider.overrideWithValue(const AppSettings()),
          frameRenderDataProvider.overrideWith(
            (ref) => const FrameRenderData(
              exif: ExifData.empty,
              config: FrameConfig(fieldOverrides: {'camera': 'manual-camera'}),
              styleId: FrameStyleId.classic,
            ),
          ),
          batchExifExtractorProvider.overrideWith((ref) {
            return (_) async => const ExifData(cameraMake: 'Canon');
          }),
          batchRendererProvider.overrideWith((ref) {
            return ({
              required String sourceImagePath,
              required ExifData exif,
              required ExportSettings settings,
              required bool isPro,
            }) async {
              renderCalls++;
              if (sourceImagePath.endsWith('b.jpg')) {
                throw Exception('render failed');
              }
              return Uint8List.fromList([1, 2, 3]);
            };
          }),
          batchSaverProvider.overrideWith((ref) {
            return (bytes, {required fileName}) async {
              saveCalls++;
              return 'gallery://$fileName';
            };
          }),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(batchExportProvider.notifier)
          .saveBatchToGallery(const ExportSettings());

      final state = container.read(batchExportProvider);
      expect(state.status, BatchExportStatus.done);
      expect(state.total, 2);
      expect(state.completed, 1);
      expect(state.failed, 1);
      expect(state.currentIndex, 0);
      expect(state.currentName, isNull);
      expect(state.errors.length, 1);
      expect(renderCalls, 2);
      expect(saveCalls, 1);
    });

    test('reports current item progress while running', () async {
      final images = [
        const ImageFile(path: '/tmp/a.jpg', name: 'a.jpg', sizeBytes: 1),
        const ImageFile(path: '/tmp/b.jpg', name: 'b.jpg', sizeBytes: 1),
      ];
      final renderStarted = Completer<void>();
      final releaseRender = Completer<void>();

      final container = ProviderContainer(
        overrides: [
          selectedBatchImagesProvider.overrideWithValue(images),
          settingsProvider.overrideWithValue(const AppSettings()),
          batchExifExtractorProvider.overrideWith((ref) {
            return (_) async => const ExifData(cameraMake: 'Canon');
          }),
          batchRendererProvider.overrideWith((ref) {
            return ({
              required String sourceImagePath,
              required ExifData exif,
              required ExportSettings settings,
              required bool isPro,
            }) async {
              if (!renderStarted.isCompleted) {
                renderStarted.complete();
              }
              await releaseRender.future;
              return Uint8List.fromList([1, 2, 3]);
            };
          }),
          batchSaverProvider.overrideWith((ref) {
            return (bytes, {required fileName}) async => 'gallery://$fileName';
          }),
        ],
      );
      addTearDown(container.dispose);

      final exportFuture = container
          .read(batchExportProvider.notifier)
          .saveBatchToGallery(const ExportSettings());
      await renderStarted.future;

      final state = container.read(batchExportProvider);
      expect(state.status, BatchExportStatus.rendering);
      expect(state.total, 2);
      expect(state.currentIndex, 1);
      expect(state.currentName, 'a.jpg');

      releaseRender.complete();
      await exportFuture;
    });

    test('ignores duplicate start while batch is running', () async {
      final images = [
        const ImageFile(path: '/tmp/a.jpg', name: 'a.jpg', sizeBytes: 1),
        const ImageFile(path: '/tmp/b.jpg', name: 'b.jpg', sizeBytes: 1),
      ];
      final renderStarted = Completer<void>();
      final releaseRender = Completer<void>();
      var renderCalls = 0;

      final container = ProviderContainer(
        overrides: [
          selectedBatchImagesProvider.overrideWithValue(images),
          settingsProvider.overrideWithValue(const AppSettings()),
          batchExifExtractorProvider.overrideWith((ref) {
            return (_) async => const ExifData(cameraMake: 'Canon');
          }),
          batchRendererProvider.overrideWith((ref) {
            return ({
              required String sourceImagePath,
              required ExifData exif,
              required ExportSettings settings,
              required bool isPro,
            }) async {
              renderCalls++;
              if (!renderStarted.isCompleted) {
                renderStarted.complete();
              }
              await releaseRender.future;
              return Uint8List.fromList([1, 2, 3]);
            };
          }),
          batchSaverProvider.overrideWith((ref) {
            return (bytes, {required fileName}) async => 'gallery://$fileName';
          }),
        ],
      );
      addTearDown(container.dispose);

      final firstExport = container
          .read(batchExportProvider.notifier)
          .saveBatchToGallery(const ExportSettings());
      await renderStarted.future;

      await container
          .read(batchExportProvider.notifier)
          .saveBatchToGallery(const ExportSettings());
      expect(renderCalls, 1);

      releaseRender.complete();
      await firstExport;
      expect(renderCalls, 2);
    });
  });
}
