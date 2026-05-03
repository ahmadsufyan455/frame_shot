import 'package:flutter/material.dart';

class ShareButtonRow extends StatelessWidget {
  const ShareButtonRow({
    super.key,
    required this.isLoading,
    required this.onSaveToGallery,
    required this.onShare,
  });

  final bool isLoading;
  final VoidCallback onSaveToGallery;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : onSaveToGallery,
            icon: const Icon(
              Icons.save_alt_outlined,
            ),
            label: const Text('Save'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: isLoading ? null : onShare,
            icon: const Icon(
              Icons.share_outlined,
            ),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}
