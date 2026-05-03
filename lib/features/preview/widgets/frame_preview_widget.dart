import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/rendering/frame_painter_factory.dart';
import '../providers/preview_providers.dart';

class FramePreviewWidget extends ConsumerWidget {
  const FramePreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(previewImageProvider);
    final renderData =
        ref.watch(frameRenderDataProvider);

    return imageAsync.when(
      data: (image) {
        if (image == null) {
          return const SizedBox.shrink();
        }

        final painter = FramePainterFactory.create(
          styleId: renderData.styleId,
          image: image,
          exif: renderData.exif,
          config: renderData.config,
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
