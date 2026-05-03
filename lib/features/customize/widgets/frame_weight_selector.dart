import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart';
import '../providers/customize_providers.dart';

class FrameWeightSelector extends ConsumerWidget {
  const FrameWeightSelector({super.key});

  static const _labels = {
    FrameWeight.thin: 'Thin',
    FrameWeight.medium: 'Medium',
    FrameWeight.thick: 'Thick',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      frameConfigProvider
          .select((c) => c.frameWeight),
    );

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<FrameWeight>(
        segments: FrameWeight.values
            .map(
              (w) => ButtonSegment(
                value: w,
                label: Text(_labels[w]!),
              ),
            )
            .toList(),
        selected: {selected},
        onSelectionChanged: (s) => ref
            .read(frameConfigProvider.notifier)
            .setFrameWeight(s.first),
      ),
    );
  }
}
