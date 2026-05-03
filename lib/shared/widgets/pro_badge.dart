import 'package:flutter/material.dart';

class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.size = 12});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.5,
        vertical: size * 0.2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(
          size * 0.4,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: size,
            color: colorScheme.onPrimary,
          ),
          SizedBox(width: size * 0.25),
          Text(
            'PRO',
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
