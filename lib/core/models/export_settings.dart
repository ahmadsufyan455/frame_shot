import '../constants/app_constants.dart';

enum ExportFormat { jpeg, png }

class ExportSettings {
  const ExportSettings({
    this.format = ExportFormat.jpeg,
    this.jpegQuality = ImageConstants.defaultExportQuality,
    this.fullResolution = false,
    this.includeWatermark = true,
  });

  final ExportFormat format;

  /// 85–100, only for JPEG.
  final int jpegQuality;

  /// false = capped at [freeMaxDimension] (free tier).
  final bool fullResolution;

  /// true for free tier.
  final bool includeWatermark;

  static const int freeMaxDimension = ImageConstants.freeMaxDimension;

  ExportSettings copyWith({
    ExportFormat? format,
    int? jpegQuality,
    bool? fullResolution,
    bool? includeWatermark,
  }) {
    return ExportSettings(
      format: format ?? this.format,
      jpegQuality: jpegQuality ?? this.jpegQuality,
      fullResolution: fullResolution ?? this.fullResolution,
      includeWatermark: includeWatermark ?? this.includeWatermark,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExportSettings &&
        other.format == format &&
        other.jpegQuality == jpegQuality &&
        other.fullResolution == fullResolution &&
        other.includeWatermark == includeWatermark;
  }

  @override
  int get hashCode =>
      Object.hash(format, jpegQuality, fullResolution, includeWatermark);
}
