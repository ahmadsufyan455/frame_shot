import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart';
import '../../../core/models/frame_customization_spec.dart';
import '../../preview/providers/style_providers.dart';
import '../providers/customize_providers.dart';

class FieldToggleList extends ConsumerWidget {
  const FieldToggleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(
      frameConfigProvider.select((c) => c.visibleFields),
    );
    final styleId = ref.watch(selectedStyleProvider);
    final fields = FrameCustomizationSpecs.forStyle(styleId).metadataFields;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: fields.map((field) {
        return SwitchListTile.adaptive(
          title: Text(
            field.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: _getValue(visibility, field.key),
          onChanged: (v) =>
              ref.read(frameConfigProvider.notifier).toggleField(field.key, v),
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  bool _getValue(ExifFieldVisibility v, String key) {
    return switch (key) {
      'camera' => v.camera,
      'lens' => v.lens,
      'aperture' => v.aperture,
      'shutterSpeed' => v.shutterSpeed,
      'iso' => v.iso,
      'focalLength' => v.focalLength,
      'exposureComp' => v.exposureComp,
      'whiteBalance' => v.whiteBalance,
      'dateTime' => v.dateTime,
      'location' => v.location,
      'dimensions' => v.dimensions,
      _ => false,
    };
  }
}
