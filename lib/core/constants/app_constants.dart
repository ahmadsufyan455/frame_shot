library;

abstract final class AppConfig {
  /// Set to `true` to unlock all pro features without purchase.
  /// MUST be `false` for production/store builds.
  static const bool forceProEnabled = true;
}

abstract final class ImageConstants {
  /// ~2MP cap for free-tier exports.
  static const int freeMaxDimension = 1600;

  /// Capped decode size for preview performance.
  static const int previewMaxDimension = 1200;

  static const int minExportQuality = 85;
  static const int maxExportQuality = 100;
  static const int defaultExportQuality = 92;

  /// Fraction of total canvas width.
  static const double watermarkSizeRatio = 0.04;
  static const double watermarkPadding = 16;
}

abstract final class DurationConstants {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 300);
}

abstract final class AppLimits {
  static const int maxPresets = 20;
  static const int maxFieldOverrideLength = 100;
  static const int maxBatchExport = 20;
}
