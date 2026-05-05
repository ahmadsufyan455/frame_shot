import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/frame_config.dart' as model;
import '../../shared/widgets/error_banner.dart';
import '../customize/customize_sheet.dart';
import '../customize/providers/customize_providers.dart';
import '../export/export_sheet.dart';
import 'providers/preview_providers.dart';
import 'widgets/frame_preview_widget.dart';
import 'widgets/style_carousel.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exifAsync = ref.watch(exifExtractionProvider);
    final isEmpty =
        exifAsync.whenOrNull(data: (d) => d?.isEmpty ?? true) ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Preview',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () => ExportSheet.show(context, ref: ref),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Export',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ErrorBanner(
                message: 'No EXIF found \u2014 tap fields to fill manually',
                actionLabel: 'Edit',
                foregroundColor: Colors.white70,
                onAction: () => CustomizeSheet.show(context, ref: ref),
              ),
            ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF111111), // Corresponds to neutral-900/40
              padding: const EdgeInsets.all(24),
              child: const FramePreviewWidget(),
            ),
          ),
          Container(
            color: const Color(0xFF0A0A0A),
            child: Column(
              children: [
                const Divider(height: 1, color: Color(0xFF171717)),
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: _AspectRatioSelector(),
                ),
                const SizedBox(height: 16),
                const StyleCarousel(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => CustomizeSheet.show(context, ref: ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tune, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Customize',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AspectRatioSelector extends ConsumerWidget {
  const _AspectRatioSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRatio = ref.watch(frameConfigProvider).aspectRatio;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _RatioButton(
              label: 'Original',
              aspectRatio: 1.2,
              isSelected: currentRatio == model.AspectRatio.original,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.original),
            ),
          ),
          Expanded(
            child: _RatioButton(
              label: '1:1',
              aspectRatio: 1.0,
              isSelected: currentRatio == model.AspectRatio.square,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.square),
            ),
          ),
          Expanded(
            child: _RatioButton(
              label: '4:5',
              aspectRatio: 4 / 5,
              isSelected: currentRatio == model.AspectRatio.fourFive,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.fourFive),
            ),
          ),
          Expanded(
            child: _RatioButton(
              label: '3:4',
              aspectRatio: 3 / 4,
              isSelected: currentRatio == model.AspectRatio.threeFour,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.threeFour),
            ),
          ),
          Expanded(
            child: _RatioButton(
              label: '16:9',
              aspectRatio: 16 / 9,
              isSelected: currentRatio == model.AspectRatio.sixteenNine,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.sixteenNine),
            ),
          ),
          Expanded(
            child: _RatioButton(
              label: '9:16',
              aspectRatio: 9 / 16,
              isSelected: currentRatio == model.AspectRatio.nineSixteen,
              onTap: () => ref
                  .read(frameConfigProvider.notifier)
                  .setAspectRatio(model.AspectRatio.nineSixteen),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatioButton extends StatelessWidget {
  const _RatioButton({
    required this.label,
    required this.aspectRatio,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final double aspectRatio;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 52,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transformAlignment: Alignment.bottomCenter,
          transform: Matrix4.diagonal3Values(
            isSelected ? 1.08 : 1.0,
            isSelected ? 1.08 : 1.0,
            1.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white38,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
