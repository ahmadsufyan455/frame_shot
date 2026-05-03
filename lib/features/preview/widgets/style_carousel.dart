import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/frame_style.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/style_providers.dart';
import 'style_card.dart';

class StyleCarousel extends ConsumerWidget {
  const StyleCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(frameStylesProvider);
    final selectedId =
        ref.watch(selectedStyleProvider);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          return StyleCard(
            style: style,
            isSelected: style.id == selectedId,
            onTap: () => _onStyleTap(
              context,
              ref,
              style,
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
