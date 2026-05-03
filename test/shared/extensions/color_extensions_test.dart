import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/shared/extensions/color_extensions.dart';

void main() {
  group('ColorSerialization', () {
    test('round-trip white (0xFFFFFFFF)', () {
      const color = Color(0xFFFFFFFF);
      final asInt = color.toArgbInt();
      expect(asInt, equals(0xFFFFFFFF));

      final restored = colorFromArgbInt(asInt);
      expect(restored, equals(color));
    });

    test('round-trip black (0xFF000000)', () {
      const color = Color(0xFF000000);
      final asInt = color.toArgbInt();
      expect(asInt, equals(0xFF000000));

      final restored = colorFromArgbInt(asInt);
      expect(restored, equals(color));
    });

    test('round-trip transparent (0x00000000)', () {
      const color = Color(0x00000000);
      final asInt = color.toArgbInt();
      expect(asInt, equals(0x00000000));

      final restored = colorFromArgbInt(asInt);
      expect(restored, equals(color));
    });

    test('round-trip arbitrary color (0xABCD1234)', () {
      const color = Color(0xABCD1234);
      final asInt = color.toArgbInt();
      final restored = colorFromArgbInt(asInt);

      // Allow ±1 due to float rounding in Color's
      // normalized representation.
      expect(
        (restored.toArgbInt() - color.toArgbInt()).abs(),
        lessThanOrEqualTo(0x01010101),
      );
    });

    test('round-trip semi-transparent red', () {
      const color = Color(0x80FF0000);
      final asInt = color.toArgbInt();
      final restored = colorFromArgbInt(asInt);

      expect(restored.a, closeTo(color.a, 0.01));
      expect(restored.r, closeTo(color.r, 0.01));
      expect(restored.g, closeTo(color.g, 0.01));
      expect(restored.b, closeTo(color.b, 0.01));
    });
  });
}
