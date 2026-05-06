import 'package:flutter_test/flutter_test.dart';
import 'package:frame_shot/core/constants/brand_logos.dart';

void main() {
  group('BrandLogos.pathForBrand', () {
    test('returns exact match for simple make', () {
      expect(
        BrandLogos.pathForBrand('nikon'),
        'assets/logos/nikon.svg',
      );
    });

    test('matches multi-word make by keyword', () {
      expect(
        BrandLogos.pathForBrand('nikon corporation nikon d750'),
        'assets/logos/nikon.svg',
      );
    });

    test('matches phone model string by keyword', () {
      expect(
        BrandLogos.pathForBrand('Samsung Galaxy s25'),
        'assets/logos/samsung.svg',
      );
    });

    test('matches spaced brand key when make is compact', () {
      expect(
        BrandLogos.pathForBrand('phaseone iq4'),
        'assets/logos/phase_one.svg',
      );
    });

    test('returns null for unknown brands', () {
      expect(BrandLogos.pathForBrand('acme camera x1'), isNull);
    });

    test('returns null for null input', () {
      expect(BrandLogos.pathForBrand(null), isNull);
    });
  });
}
