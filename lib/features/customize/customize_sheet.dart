import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/frame_config.dart';
import '../../core/models/frame_customization_spec.dart';
import '../preview/providers/style_providers.dart';
import '../settings/providers/settings_providers.dart';
import 'providers/customize_providers.dart';
import 'widgets/color_picker_row.dart';
import 'widgets/field_override_tile.dart';
import 'widgets/field_toggle_list.dart';

class CustomizeSheet extends ConsumerWidget {
  const CustomizeSheet({super.key, required this.onAdvancedPressed});

  final VoidCallback onAdvancedPressed;

  static void show(BuildContext context, {WidgetRef? ref}) {
    if (ref != null) {
      final isPro = ref.read(proStatusProvider).value ?? false;
      if (!isPro) {
        context.pushNamed('paywall');
        return;
      }
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => CustomizeSheet(
        onAdvancedPressed: () {
          Navigator.of(sheetContext).pop();
          Future<void>.delayed(const Duration(milliseconds: 180), () {
            if (context.mounted) {
              showAdvanced(context);
            }
          });
        },
      ),
    );
  }

  static void showAdvanced(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AdvancedCustomizeSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final showLogo = ref.watch(
      frameConfigProvider.select((config) => config.showCameraLogo),
    );
    final frameWeight = ref.watch(
      frameConfigProvider.select((config) => config.frameWeight),
    );
    final styleId = ref.watch(selectedStyleProvider);
    final spec = FrameCustomizationSpecs.forStyle(styleId);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 28 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pro Customization',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFA1A1A1),
                  minimumSize: const Size(48, 36),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (spec.supportsCameraLogo) ...[
            _QuickControlRow(
              label: 'Camera Logo',
              trailing: _CompactSwitch(
                value: showLogo,
                onChanged: (value) => ref
                    .read(frameConfigProvider.notifier)
                    .toggleCameraLogo(value),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _QuickControlRow(
            label: 'Border Weight',
            trailing: _FrameWeightPills(
              selected: frameWeight,
              onChanged: (value) =>
                  ref.read(frameConfigProvider.notifier).setFrameWeight(value),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: onAdvancedPressed,
            child: const Text.rich(
              TextSpan(
                text: 'More customization options available in ',
                children: [
                  TextSpan(
                    text: 'Advanced',
                    style: TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF60A5FA),
                    ),
                  ),
                  TextSpan(text: ' →'),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.35,
                letterSpacing: 0,
                color: Color(0xFFA1A1A1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvancedCustomizeSheet extends ConsumerWidget {
  const _AdvancedCustomizeSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styleId = ref.watch(selectedStyleProvider);
    final spec = FrameCustomizationSpecs.forStyle(styleId);
    final baseTheme = Theme.of(context);
    final advancedTheme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: const Color(0xFF171717),
        onSurface: Colors.white,
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: const Color(0xFFE5E5E5),
        outline: const Color(0xFFA3A3A3),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFA3A3A3)),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFFA3A3A3),
        textColor: Colors.white,
      ),
      dividerColor: const Color(0xFF262626),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: const Color(0xFF262626),
        selectedColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return const Color(0xFFE5E5E5);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return const Color(0xFF404040);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Theme(
          data: advancedTheme,
          child: SafeArea(
            top: false,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const _AdvancedHeader(),
                const SizedBox(height: 24),
                if (spec.supportsAccentColor ||
                    spec.supportsBackgroundColor ||
                    spec.supportsTextColor) ...[
                  const _SectionHeader(title: 'Colors'),
                  _StyleColorControls(spec: spec),
                  const SizedBox(height: 20),
                ],
                const _SectionHeader(title: 'Show / Hide'),
                const FieldToggleList(),
                const SizedBox(height: 20),
                const _SectionHeader(title: 'Override Values'),
                const FieldOverrideList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AdvancedHeader extends StatelessWidget {
  const _AdvancedHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Advanced',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFA1A1A1),
            minimumSize: const Size(48, 36),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _StyleColorControls extends StatelessWidget {
  const _StyleColorControls({required this.spec});

  final FrameCustomizationSpec spec;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (spec.supportsAccentColor) const AccentColorPicker(),
        if (spec.supportsAccentColor &&
            (spec.supportsBackgroundColor || spec.supportsTextColor))
          const SizedBox(width: 28),
        if (spec.supportsBackgroundColor) const BackgroundColorPicker(),
        if (spec.supportsBackgroundColor && spec.supportsTextColor)
          const SizedBox(width: 28),
        if (spec.supportsTextColor) const TextColorPicker(),
      ],
    );
  }
}

class _QuickControlRow extends StatelessWidget {
  const _QuickControlRow({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: const TextStyle(
        color: Color(0xFFD4D4D4),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 320) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText,
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: trailing),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: labelText),
            const SizedBox(width: 16),
            trailing,
          ],
        );
      },
    );
  }
}

class _CompactSwitch extends StatelessWidget {
  const _CompactSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      button: true,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 48,
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 48,
              height: 24,
              decoration: BoxDecoration(
                color: value ? Colors.white : const Color(0xFF262626),
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: value ? Colors.black : const Color(0xFFA1A1A1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrameWeightPills extends StatelessWidget {
  const _FrameWeightPills({required this.selected, required this.onChanged});

  static const _labels = {
    FrameWeight.thin: 'Thin',
    FrameWeight.medium: 'Med',
    FrameWeight.thick: 'Thick',
  };

  final FrameWeight selected;
  final ValueChanged<FrameWeight> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: FrameWeight.values.map((weight) {
        final isSelected = selected == weight;
        return Padding(
          padding: EdgeInsets.only(left: weight == FrameWeight.thin ? 0 : 8),
          child: GestureDetector(
            onTap: () => onChanged(weight),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              height: 28,
              constraints: const BoxConstraints(minWidth: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFF262626),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _labels[weight]!,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.3,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}
