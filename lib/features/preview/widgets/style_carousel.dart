import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/exif_data.dart';
import '../../../core/models/frame_style.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/preview_providers.dart';
import '../providers/style_providers.dart';
import 'frame_preview_widget.dart';
import 'style_card.dart';

class StyleCarousel extends ConsumerWidget {
  const StyleCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(frameStylesProvider);
    final selectedId =
        ref.watch(selectedStyleProvider);
    final isUserPro =
        ref.watch(proStatusProvider).value ?? false;

    final image = ref.watch(previewImageProvider).value;
    final exif =
        ref.watch(exifExtractionProvider).value ??
            ExifData.empty;
    final cameraLogo =
        ref.watch(cameraLogoImageProvider).value;

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: StyleCard(
              style: style,
              isSelected: style.id == selectedId,
              isUserPro: isUserPro,
              image: image,
              exif: exif,
              cameraLogo: cameraLogo,
              onTap: () => _onStyleTap(
                context,
                ref,
                style,
              ),
            ),
          );
        },
      ),
    );
  }

  void _onStyleTap(
    BuildContext context,
    WidgetRef ref,
    FrameStyle style,
  ) {
    if (style.isPro) {
      final isPro =
          ref.read(proStatusProvider).value ?? false;
      if (!isPro) {
        context.pushNamed('paywall');
        return;
      }
    }
    ref
        .read(selectedStyleProvider.notifier)
        .select(style.id);
  }
}
