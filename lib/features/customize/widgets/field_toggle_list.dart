import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/frame_config.dart';
import '../providers/customize_providers.dart';

class FieldToggleList extends ConsumerWidget {
  const FieldToggleList({super.key});

  /// Primary fields the user can toggle on/off.
  /// Secondary fields (aperture, shutter, ISO, etc.)
  /// are always enabled and curated by each frame
  /// style.
  static const _fields = [
    ('camera', 'Camera'),
    ('lens', 'Lens'),
    ('dateTime', 'Date & Time'),
    ('location', 'Location'),
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
      'dateTime' => v.dateTime,
      'location' => v.location,
      _ => false,
    };
  }
}
