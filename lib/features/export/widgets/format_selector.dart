import 'package:flutter/material.dart';

import '../../../core/models/export_settings.dart';

class FormatSelector extends StatelessWidget {
  const FormatSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ExportFormat selected;
  final ValueChanged<ExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ExportFormat>(
        segments: const [
          ButtonSegment(
            value: ExportFormat.jpeg,
            label: Text('JPEG'),
            icon: Icon(Icons.image_outlined),
          ),
          ButtonSegment(
            value: ExportFormat.png,
            label: Text('PNG'),
            icon: Icon(Icons.image_outlined),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (s) =>
            onChanged(s.first),
      ),
    );
  }
}
