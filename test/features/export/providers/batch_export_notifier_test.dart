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
      expect(state.errors.length, 1);
      expect(renderCalls, 2);
      expect(saveCalls, 1);
    });
  });
}
