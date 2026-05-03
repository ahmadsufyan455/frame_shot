import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/customize_providers.dart';

class ColorPickerRow extends ConsumerWidget {
  const ColorPickerRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(frameConfigProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ColorCircle(
          label: 'Background',
          color: config.backgroundColor,
          onColorChanged: (c) => ref
              .read(frameConfigProvider.notifier)
              .updateBackgroundColor(c),
        ),
        _ColorCircle(
          label: 'Text',
          color: config.textColor,
          onColorChanged: (c) => ref
              .read(frameConfigProvider.notifier)
              .updateTextColor(c),
        ),
        _ColorCircle(
          label: 'Accent',
          color: config.accentColor,
          onColorChanged: (c) => ref
              .read(frameConfigProvider.notifier)
              .updateAccentColor(c),
        ),
      ],
    );
  }
}

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style:
                Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    var picked = color;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Pick $label Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (c) => picked = c,
            enableAlpha: false,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onColorChanged(picked);
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
