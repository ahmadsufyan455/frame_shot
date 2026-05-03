import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class QualitySlider extends StatelessWidget {
  const QualitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'JPEG Quality',
              style: textTheme.bodyMedium,
            ),
            Text(
              '$value%',
              style: textTheme.labelLarge,
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: ImageConstants.minExportQuality
              .toDouble(),
          max: ImageConstants.maxExportQuality
              .toDouble(),
          divisions:
              ImageConstants.maxExportQuality -
                  ImageConstants.minExportQuality,
          label: '$value%',
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}
