import 'package:flutter/material.dart' hide AspectRatio;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart'
    show AspectRatio;
import '../providers/customize_providers.dart';

class AspectRatioSelector extends ConsumerWidget {
  const AspectRatioSelector({super.key});

  static const _labels = <AspectRatio, String>{
    AspectRatio.original: 'Original',
    AspectRatio.square: '1:1',
    AspectRatio.fourFive: '4:5',
    AspectRatio.sixteenNine: '16:9',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      frameConfigProvider
          .select((c) => c.aspectRatio),
    );

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<AspectRatio>(
        segments: AspectRatio.values
            .map(
              (r) => ButtonSegment<AspectRatio>(
                value: r,
                label: Text(_labels[r]!),
              ),
            )
            .toList(),
        selected: {selected},
        onSelectionChanged: (s) => ref
            .read(frameConfigProvider.notifier)
            .setAspectRatio(s.first),
      ),
    );
  }
}
