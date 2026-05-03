import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/rendering/brand_logo_loader.dart';
import '../../../core/rendering/frame_painter_factory.dart';
import '../providers/preview_providers.dart';

part 'frame_preview_widget.g.dart';

@riverpod
Future<ui.Image?> cameraLogoImage(Ref ref) async {
  final renderData = ref.watch(frameRenderDataProvider);
  if (!renderData.config.showCameraLogo) return null;
  return BrandLogoLoader.load(
    renderData.exif.cameraMake,
  );
}

class FramePreviewWidget extends ConsumerWidget {
  const FramePreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(previewImageProvider);
    final renderData =
        ref.watch(frameRenderDataProvider);
    final logoAsync =
        ref.watch(cameraLogoImageProvider);

    return imageAsync.when(
      data: (image) {
        if (image == null) {
          return const SizedBox.shrink();
        }

        final cameraLogo = logoAsync.value;

        final painter = FramePainterFactory.create(
          styleId: renderData.styleId,
          image: image,
          exif: renderData.exif,
          config: renderData.config,
          cameraLogo: cameraLogo,
        );

        final totalSize = painter.calculateTotalSize(
          Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
        );

        return RepaintBoundary(
          child: FittedBox(
            child: CustomPaint(
              size: totalSize,
              painter: painter,
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text('Error: $e'),
      ),
    );
  }
}
