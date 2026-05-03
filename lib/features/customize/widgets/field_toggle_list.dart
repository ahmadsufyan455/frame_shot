import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart';
import '../providers/customize_providers.dart';

class FieldToggleList extends ConsumerWidget {
  const FieldToggleList({super.key});

  static const _fields = [
    ('camera', 'Camera'),
    ('lens', 'Lens'),
    ('aperture', 'Aperture'),
    ('shutterSpeed', 'Shutter Speed'),
    ('iso', 'ISO'),
    ('focalLength', 'Focal Length'),
    ('exposureComp', 'Exposure Comp'),
    ('whiteBalance', 'White Balance'),
    ('dateTime', 'Date & Time'),
    ('location', 'Location'),
    ('dimensions', 'Dimensions'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(
      frameConfigProvider
          .select((c) => c.visibleFields),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _fields.map((entry) {
        final (key, label) = entry;
        return SwitchListTile.adaptive(
          title: Text(
            label,
            style:
                Theme.of(context).textTheme.bodyMedium,
          ),
          value: _getValue(visibility, key),
          onChanged: (v) => ref
              .read(frameConfigProvider.notifier)
              .toggleField(key, v),
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  bool _getValue(
    ExifFieldVisibility v,
    String key,
  ) {
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
