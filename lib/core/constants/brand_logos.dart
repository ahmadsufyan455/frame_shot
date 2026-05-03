abstract final class BrandLogos {
  static const Map<String, String> map = {
    'sony': 'assets/logos/sony.svg',
    'canon': 'assets/logos/canon.svg',
    'nikon': 'assets/logos/nikon.svg',
    'fujifilm': 'assets/logos/fujifilm.svg',
    'panasonic': 'assets/logos/panasonic.svg',
    'olympus': 'assets/logos/olympus.svg',
    'leica': 'assets/logos/leica.svg',
    'hasselblad': 'assets/logos/hasselblad.svg',
    'samsung': 'assets/logos/samsung.svg',
    'apple': 'assets/logos/apple.svg',
    'google': 'assets/logos/google.svg',
    'xiaomi': 'assets/logos/xiaomi.svg',
    'oppo': 'assets/logos/oppo.svg',
    'vivo': 'assets/logos/vivo.svg',
    'huawei': 'assets/logos/huawei.svg',
    'oneplus': 'assets/logos/oneplus.svg',
    'dji': 'assets/logos/dji.svg',
    'gopro': 'assets/logos/gopro.svg',
    'ricoh': 'assets/logos/ricoh.svg',
    'sigma': 'assets/logos/sigma.svg',
    'tamron': 'assets/logos/tamron.svg',
    'pentax': 'assets/logos/pentax.svg',
    'phase one': 'assets/logos/phase_one.svg',
    'blackmagic': 'assets/logos/blackmagic.svg',
    'insta360': 'assets/logos/insta360.svg',
    'realme': 'assets/logos/realme.svg',
    'motorola': 'assets/logos/motorola.svg',
    'nothing': 'assets/logos/nothing.svg',
    'asus': 'assets/logos/asus.svg',
    'honor': 'assets/logos/honor.svg',
  };

  static String? pathForBrand(String? brand) {
    if (brand == null) return null;
    return map[brand.toLowerCase()];
  }
}
