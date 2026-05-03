import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/exif_data.dart';
import '../providers/customize_providers.dart';

class FieldOverrideTile extends ConsumerWidget {
  const FieldOverrideTile({
    super.key,
    required this.fieldName,
    required this.label,
  });

  final String fieldName;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exif = ref.watch(editedExifProvider);
    final current = _resolveValue(exif);
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        current ?? '\u2014',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: colorScheme.outline),
      ),
      trailing: const Icon(Icons.edit_outlined, size: 18),
      onTap: () => _showEditDialog(
        context,
        ref,
        current,
      ),
    );
  }

  String? _resolveValue(ExifData exif) {
    return switch (fieldName) {
      'cameraMake' => exif.cameraMake,
      'cameraModel' => exif.cameraModel,
      'lensModel' => exif.lensModel,
      'shutterSpeed' => exif.shutterSpeed,
      'whiteBalance' => exif.whiteBalance,
      'locationName' => exif.locationName,
      _ => null,
    };
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) {
    final controller =
        TextEditingController(text: current);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $label',
          ),
          onSubmitted: (value) {
            ref
                .read(editedExifProvider.notifier)
                .updateField(fieldName, value);
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(editedExifProvider.notifier)
                  .updateField(
                    fieldName,
                    controller.text,
                  );
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
