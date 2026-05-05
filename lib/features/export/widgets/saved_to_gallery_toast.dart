import 'package:flutter/material.dart';

void showSavedToGalleryToast(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final toastWidth = screenWidth < 396 ? screenWidth - 40 : 356.0;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        width: toastWidth,
        duration: const Duration(seconds: 3),
        content: const _SavedToGalleryToast(),
      ),
    );
}

class _SavedToGalleryToast extends StatelessWidget {
  const _SavedToGalleryToast();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 13, right: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFFFCFCFC), size: 20),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Saved to Gallery!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFFFCFCFC),
                fontFamily: 'sans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
