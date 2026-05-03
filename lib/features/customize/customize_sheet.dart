import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../settings/providers/settings_providers.dart';
import 'widgets/aspect_ratio_selector.dart';
import 'widgets/color_picker_row.dart';
import 'widgets/field_override_tile.dart';
import 'widgets/field_toggle_list.dart';
import 'widgets/font_picker.dart';
import 'widgets/frame_weight_selector.dart';
import 'widgets/logo_toggle.dart';

class CustomizeSheet extends StatelessWidget {
  const CustomizeSheet({super.key});

  static void show(
    BuildContext context, {
    WidgetRef? ref,
  }) {
    if (ref != null) {
      final isPro =
          ref.read(proStatusProvider).value ?? false;
      if (!isPro) {
        context.pushNamed('paywall');
        return;
      }
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CustomizeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          children: const [
            _SectionHeader(title: 'Colors'),
            ColorPickerRow(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Font'),
            FontPicker(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Aspect Ratio'),
            AspectRatioSelector(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Frame Weight'),
            FrameWeightSelector(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Display'),
            LogoToggle(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Visible Fields'),
            FieldToggleList(),
            SizedBox(height: 20),
            _SectionHeader(title: 'Override Values'),
            FieldOverrideTile(
              fieldName: 'cameraMake',
              label: 'Camera Make',
            ),
            FieldOverrideTile(
              fieldName: 'cameraModel',
              label: 'Camera Model',
            ),
            FieldOverrideTile(
              fieldName: 'lensModel',
              label: 'Lens Model',
            ),
            FieldOverrideTile(
              fieldName: 'shutterSpeed',
              label: 'Shutter Speed',
            ),
            FieldOverrideTile(
              fieldName: 'whiteBalance',
              label: 'White Balance',
            ),
            FieldOverrideTile(
              fieldName: 'locationName',
              label: 'Location',
            ),
            SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style:
            Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
