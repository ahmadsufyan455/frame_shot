import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/export_settings.dart';
import '../settings/providers/settings_providers.dart';
import 'providers/export_providers.dart';

class ExportSheet extends ConsumerStatefulWidget {
  const ExportSheet({super.key});

  static void show(BuildContext context, {required WidgetRef ref}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExportSheet(),
    );
  }

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<ExportSheet> {
  var _settings = const ExportSettings();
  _Action _lastAction = _Action.unknown;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isPro = ref.watch(proStatusProvider).value ?? false;
    final exportState = ref.watch(exportProvider);

    ref.listen<ExportState>(exportProvider, (prev, next) {
      if (next.error != null) {
        _showErrorSnackBar(next.error!);
      }
      if (next.status == ExportStatus.done &&
          next.savedPath != null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to gallery')),
        );
      }
    });

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24, 24, 24, 28 + bottomPadding,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF171717),
            border: Border(
              top: BorderSide(color: Color(0xFF262626)),
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 40,
                offset: Offset(0, -12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                onDone: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
              _FormatSection(
                selected: _settings.format,
                onChanged: (f) => setState(() {
                  _settings = _settings.copyWith(format: f);
                }),
              ),
              if (_settings.format == ExportFormat.jpeg) ...[
                const SizedBox(height: 20),
                _QualitySection(
                  value: _settings.jpegQuality,
                  onChanged: (q) => setState(() {
                    _settings =
                        _settings.copyWith(jpegQuality: q);
                  }),
                ),
              ],
              const SizedBox(height: 20),
              _ResolutionIndicator(
                isPro: isPro,
                onUpgrade: () {
                  Navigator.of(context).pop();
                  context.pushNamed('paywall');
                },
              ),
              const SizedBox(height: 28),
              _ActionButtons(
                status: exportState.status,
                lastAction: _lastAction,
                onSave: () {
                  _lastAction = _Action.save;
                  ref
                      .read(exportProvider.notifier)
                      .saveToGallery(_settings);
                },
                onShare: () {
                  _lastAction = _Action.share;
                  ref
                      .read(exportProvider.notifier)
                      .shareToApp(_settings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export failed: $error'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Export',
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
          onPressed: onDone,
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
    );
  }
}

class _FormatSection extends StatelessWidget {
  const _FormatSection({
    required this.selected,
    required this.onChanged,
  });

  final ExportFormat selected;
  final ValueChanged<ExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Format',
          style: TextStyle(
            color: Color(0xFFD4D4D4),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        _DarkFormatSelector(
          selected: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DarkFormatSelector extends StatelessWidget {
  const _DarkFormatSelector({
    required this.selected,
    required this.onChanged,
  });

  final ExportFormat selected;
  final ValueChanged<ExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ExportFormat.values.map((format) {
        final isSelected = selected == format;
        final label = format == ExportFormat.jpeg
            ? 'JPEG'
            : 'PNG';
        return Padding(
          padding: EdgeInsets.only(
            left: format == ExportFormat.jpeg ? 0 : 8,
          ),
          child: GestureDetector(
            onTap: () => onChanged(format),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              height: 36,
              constraints: const BoxConstraints(minWidth: 72),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF262626),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.black
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
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

class _QualitySection extends StatelessWidget {
  const _QualitySection({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quality',
              style: TextStyle(
                color: Color(0xFFD4D4D4),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
            Text(
              '$value%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: const Color(0xFF262626),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.toDouble(),
            min: ImageConstants.minExportQuality.toDouble(),
            max: ImageConstants.maxExportQuality.toDouble(),
            divisions: ImageConstants.maxExportQuality -
                ImageConstants.minExportQuality,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
      ],
    );
  }
}

class _ResolutionIndicator extends StatelessWidget {
  const _ResolutionIndicator({
    required this.isPro,
    required this.onUpgrade,
  });

  final bool isPro;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isPro
                ? Icons.check_circle_outline
                : Icons.photo_size_select_large_outlined,
            color: isPro
                ? const Color(0xFF34C759)
                : const Color(0xFFA1A1A1),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isPro
                  ? 'Full resolution'
                  : 'Capped at '
                      '${ImageConstants.freeMaxDimension}px',
              style: TextStyle(
                color: isPro
                    ? Colors.white
                    : const Color(0xFFA1A1A1),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
          ),
          if (!isPro)
            GestureDetector(
              onTap: onUpgrade,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.status,
    required this.lastAction,
    required this.onSave,
    required this.onShare,
  });

  final ExportStatus status;
  final _Action lastAction;
  final VoidCallback onSave;
  final VoidCallback onShare;

  bool get _isLoading =>
      status != ExportStatus.idle &&
      status != ExportStatus.done;

  @override
  Widget build(BuildContext context) {
    final saveLoading = _isLoading &&
        (status == ExportStatus.saving ||
            (status == ExportStatus.rendering &&
                lastAction == _Action.save));
    final shareLoading = _isLoading &&
        (status == ExportStatus.sharing ||
            (status == ExportStatus.rendering &&
                lastAction == _Action.share));

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Save',
            icon: Icons.save_alt_outlined,
            isPrimary: true,
            isLoading: saveLoading,
            isDisabled: _isLoading,
            onTap: onSave,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: 'Share',
            icon: Icons.share_outlined,
            isPrimary: false,
            isLoading: shareLoading,
            isDisabled: _isLoading,
            onTap: onShare,
          ),
        ),
      ],
    );
  }
}

enum _Action { save, share, unknown }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fgColor = isPrimary ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary
              ? (isDisabled
                  ? const Color(0xFF262626)
                  : Colors.white)
              : const Color(0xFF262626),
          borderRadius: BorderRadius.circular(14),
          border: isPrimary
              ? null
              : Border.all(color: const Color(0xFF404040)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fgColor.withValues(alpha: 0.5),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: fgColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
