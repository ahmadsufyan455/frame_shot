import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/error_banner.dart';
import '../customize/customize_sheet.dart';
import 'providers/preview_providers.dart';
import 'widgets/frame_preview_widget.dart';
import 'widgets/style_carousel.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exifAsync =
        ref.watch(exifExtractionProvider);
    final isEmpty = exifAsync.whenOrNull(
          data: (d) => d?.isEmpty ?? true,
        ) ??
        false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () =>
                CustomizeSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_outlined),
            onPressed: () =>
                context.pushNamed('export'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16, 8, 16, 0,
              ),
              child: ErrorBanner(
                message: 'No EXIF found \u2014 '
                    'tap fields to fill manually',
                actionLabel: 'Edit',
                onAction: () =>
                    CustomizeSheet.show(context),
              ),
            ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: FramePreviewWidget(),
            ),
          ),
          const StyleCarousel(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
