import 'package:flutter/material.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key});

  static const _features = <(String, bool, bool)>[
    ('Frame Styles', false, true),
    ('Full Resolution Export', false, true),
    ('No Watermark', false, true),
    ('Color Customization', false, true),
    ('Custom Fonts', false, true),
    ('Camera Brand Logo', false, true),
    ('Field Overrides', false, true),
    ('Share to Social', true, true),
    ('Auto EXIF Read', true, true),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(colorScheme, textTheme),
          ..._features.map(
            (f) => _FeatureRow(
              label: f.$1,
              free: f.$2,
              pro: f.$3,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      color: colorScheme.primary,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Feature',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              'Free',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              'Pro',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.label,
    required this.free,
    required this.pro,
  });

  final String label;
  final bool free;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
          SizedBox(
            width: 56,
            child: Icon(
              free
                  ? Icons.check_circle
                  : Icons.remove_circle_outline,
              size: 20,
              color: free
                  ? colorScheme.primary
                  : colorScheme.outline
                      .withValues(alpha: 0.4),
            ),
          ),
          SizedBox(
            width: 56,
            child: Icon(
              Icons.check_circle,
              size: 20,
              color: pro
                  ? colorScheme.primary
                  : colorScheme.outline
                      .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
