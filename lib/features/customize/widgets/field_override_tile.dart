import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/exif_data.dart';
import '../../../core/models/frame_customization_spec.dart';
import '../../../shared/extensions/exif_format_extensions.dart';
import '../../preview/providers/style_providers.dart';
import '../providers/customize_providers.dart';

class FieldOverrideList extends ConsumerWidget {
  const FieldOverrideList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styleId = ref.watch(selectedStyleProvider);
    final fields = FrameCustomizationSpecs.forStyle(styleId).metadataFields;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: fields
          .map(
            (field) =>
                FieldOverrideTile(fieldName: field.key, label: field.label),
          )
          .toList(),
    );
  }
}

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
    final config = ref.watch(frameConfigProvider);
    final override = config.fieldOverrides[fieldName];
    final fallback = _resolveValue(exif);
    final current = override ?? fallback;
    final hasOverride = override != null;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        current ?? '\u2014',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: hasOverride ? colorScheme.onSurface : colorScheme.outline,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasOverride)
            IconButton(
              tooltip: 'Clear override',
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => ref
                  .read(frameConfigProvider.notifier)
                  .setFieldOverride(fieldName, ''),
            ),
          const Icon(Icons.edit_outlined, size: 18),
        ],
      ),
      onTap: () => _showEditDialog(context, ref, current ?? ''),
    );
  }

  String? _resolveValue(ExifData exif) {
    return switch (fieldName) {
      'camera' => exif.displayCameraName,
      'lens' => exif.lensModel,
      'aperture' => exif.formattedAperture,
      'shutterSpeed' => exif.formattedShutterSpeed,
      'iso' => exif.formattedIso,
      'focalLength' => exif.formattedFocalLength,
      'exposureComp' => exif.formattedExposureComp,
      'whiteBalance' => exif.formattedWhiteBalance,
      'dateTime' => exif.formattedDateTime,
      'location' => exif.formattedLocation,
      'dimensions' => exif.displayDimensions,
      _ => null,
    };
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, String current) {
    final controller = TextEditingController(text: current);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Edit $label',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: colorScheme.onSurface),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
          onSubmitted: (value) {
            ref
                .read(frameConfigProvider.notifier)
                .setFieldOverride(fieldName, value.trim());
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(frameConfigProvider.notifier)
                  .setFieldOverride(fieldName, controller.text.trim());
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
