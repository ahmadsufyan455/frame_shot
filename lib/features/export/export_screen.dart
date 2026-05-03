import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/export_settings.dart';
import 'providers/export_providers.dart';
import 'widgets/format_selector.dart';
import 'widgets/quality_slider.dart';
import 'widgets/share_button_row.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() =>
      _ExportScreenState();
}

class _ExportScreenState
    extends ConsumerState<ExportScreen> {
  var _settings = const ExportSettings();

  @override
  Widget build(BuildContext context) {
    final exportState =
        ref.watch(exportProvider);
    final isLoading =
        exportState.status != ExportStatus.idle &&
            exportState.status != ExportStatus.done;

    ref.listen<ExportState>(
      exportProvider,
      (prev, next) {
        if (next.error != null) {
          _showErrorDialog(
            context,
            ref,
            next.error!,
            prev?.status ?? ExportStatus.idle,
          );
        }
        if (next.status == ExportStatus.done &&
            next.savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved to gallery'),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Format',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),
              const SizedBox(height: 8),
              FormatSelector(
                selected: _settings.format,
                onChanged: (f) => setState(() {
                  _settings =
                      _settings.copyWith(format: f);
                }),
              ),
              const SizedBox(height: 24),
              if (_settings.format ==
                  ExportFormat.jpeg) ...[
                QualitySlider(
                  value: _settings.jpegQuality,
                  onChanged: (q) => setState(() {
                    _settings = _settings.copyWith(
                      jpegQuality: q,
                    );
                  }),
                ),
                const SizedBox(height: 24),
              ],
              if (isLoading) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        _statusLabel(
                          exportState.status,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              ShareButtonRow(
                isLoading: isLoading,
                onSaveToGallery: () => ref
                    .read(
                      exportProvider
                          .notifier,
                    )
                    .saveToGallery(_settings),
                onShare: () => ref
                    .read(
                      exportProvider
                          .notifier,
                    )
                    .shareToApp(_settings),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    WidgetRef ref,
    String error,
    ExportStatus previousStatus,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(ctx).colorScheme.error,
        ),
        title: const Text('Export Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final notifier = ref.read(
                exportProvider.notifier,
              );
              if (previousStatus ==
                  ExportStatus.saving) {
                notifier.saveToGallery(_settings);
              } else {
                notifier.shareToApp(_settings);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _statusLabel(ExportStatus status) {
    return switch (status) {
      ExportStatus.rendering => 'Rendering\u2026',
      ExportStatus.saving => 'Saving\u2026',
      ExportStatus.sharing => 'Preparing\u2026',
      _ => '',
    };
  }
}
