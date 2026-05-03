import 'package:flutter/painting.dart';

extension ColorSerialization on Color {
  /// Converts to 32-bit ARGB int for JSON/SharedPreferences.
  int toArgbInt() {
    final alpha = (a * 255).round();
    final red = (r * 255).round();
    final green = (g * 255).round();
    final blue = (b * 255).round();
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }
}

/// Standalone because Dart doesn't support extension
/// constructors.
Color colorFromArgbInt(int value) {
  return Color.fromARGB(
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  );
}
