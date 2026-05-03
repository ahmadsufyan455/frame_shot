import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../customize/customize_sheet.dart';
import 'widgets/frame_preview_widget.dart';
import 'widgets/style_carousel.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: FramePreviewWidget(),
            ),
          ),
          StyleCarousel(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
