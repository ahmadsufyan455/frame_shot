import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/models/export_settings.dart';

void main() {
  group('ExportSettings', () {
    test('defaults match TDD spec', () {
      const settings = ExportSettings();
      expect(settings.format, ExportFormat.jpeg);
      expect(settings.jpegQuality, 92);
      expect(settings.fullResolution, false);
      expect(settings.includeWatermark, true);
    });

    test('freeMaxDimension is 1600', () {
      expect(ExportSettings.freeMaxDimension, 1600);
    });

    test('copyWith works', () {
      const settings = ExportSettings();
      final updated = settings.copyWith(
        format: ExportFormat.png,
        fullResolution: true,
        includeWatermark: false,
      );
      expect(updated.format, ExportFormat.png);
      expect(updated.fullResolution, true);
      expect(updated.includeWatermark, false);
      expect(updated.jpegQuality, 92);
    });

    test('equality', () {
      const a = ExportSettings();
      const b = ExportSettings();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('ExportFormat has 2 values', () {
      expect(ExportFormat.values.length, 2);
    });
  });
}
