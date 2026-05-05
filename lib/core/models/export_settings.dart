import '../constants/app_constants.dart';

enum ExportFormat { jpeg, png }

class ExportSettings {
  const ExportSettings({
    this.format = ExportFormat.jpeg,
    this.jpegQuality = ImageConstants.defaultExportQuality,
  });

  final ExportFormat format;

  /// 85–100, only for JPEG.
  final int jpegQuality;

  ExportSettings copyWith({
    ExportFormat? format,
    int? jpegQuality,
  }) {
    return ExportSettings(
      format: format ?? this.format,
      jpegQuality: jpegQuality ?? this.jpegQuality,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExportSettings &&
        other.format == format &&
        other.jpegQuality == jpegQuality;
  }

  @override
  int get hashCode => Object.hash(format, jpegQuality);
}
