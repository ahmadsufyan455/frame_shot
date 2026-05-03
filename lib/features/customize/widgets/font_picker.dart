import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart';
import '../providers/customize_providers.dart';

class FontPicker extends ConsumerWidget {
  const FontPicker({super.key});

  static const _labels = {
    FrameFontFamily.serif: 'Serif',
    FrameFontFamily.sans: 'Sans',
    FrameFontFamily.mono: 'Mono',
    FrameFontFamily.displayA: 'Display A',
    FrameFontFamily.displayB: 'Display B',
    FrameFontFamily.handwritten: 'Handwritten',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      frameConfigProvider
          .select((c) => c.fontFamily),
    );

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: FrameFontFamily.values.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final font = FrameFontFamily.values[index];
          final isSelected = font == selected;
          return ChoiceChip(
            label: Text(_labels[font]!),
            selected: isSelected,
            onSelected: (_) => ref
                .read(frameConfigProvider.notifier)
                .setFont(font),
          );
        },
      ),
    );
  }
}
