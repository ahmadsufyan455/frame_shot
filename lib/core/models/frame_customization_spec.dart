import 'frame_style.dart';

class FrameCustomizationField {
  const FrameCustomizationField({required this.key, required this.label});

  final String key;
  final String label;
}

class FrameCustomizationSpec {
  const FrameCustomizationSpec({
    required this.metadataFields,
    this.supportsCameraLogo = false,
    this.supportsAccentColor = false,
    this.supportsBackgroundColor = false,
    this.supportsTextColor = false,
  });

  final List<FrameCustomizationField> metadataFields;
  final bool supportsCameraLogo;
  final bool supportsAccentColor;
  final bool supportsBackgroundColor;
  final bool supportsTextColor;
}

abstract final class FrameCustomizationFields {
  static const camera = FrameCustomizationField(key: 'camera', label: 'Camera');
  static const lens = FrameCustomizationField(key: 'lens', label: 'Lens');
  static const aperture = FrameCustomizationField(
    key: 'aperture',
    label: 'Aperture',
  );
  static const shutterSpeed = FrameCustomizationField(
    key: 'shutterSpeed',
    label: 'Shutter Speed',
  );
  static const iso = FrameCustomizationField(key: 'iso', label: 'ISO');
  static const focalLength = FrameCustomizationField(
    key: 'focalLength',
    label: 'Focal Length',
  );
  static const dateTime = FrameCustomizationField(
    key: 'dateTime',
    label: 'Date & Time',
  );
}

abstract final class FrameCustomizationSpecs {
  static const _classic = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.lens,
      FrameCustomizationFields.focalLength,
      FrameCustomizationFields.aperture,
      FrameCustomizationFields.shutterSpeed,
      FrameCustomizationFields.iso,
    ],
  );

  static const _darkroom = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.lens,
      FrameCustomizationFields.focalLength,
      FrameCustomizationFields.aperture,
      FrameCustomizationFields.shutterSpeed,
      FrameCustomizationFields.iso,
    ],
  );

  static const _filmBorder = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.aperture,
      FrameCustomizationFields.shutterSpeed,
    ],
  );

  static const _minimalLine = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.focalLength,
      FrameCustomizationFields.aperture,
    ],
  );

  static const _fujifilmSim = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.focalLength,
    ],
  );

  static const _architect = FrameCustomizationSpec(
    supportsAccentColor: true,
    supportsBackgroundColor: true,
    supportsTextColor: true,
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.focalLength,
      FrameCustomizationFields.aperture,
      FrameCustomizationFields.shutterSpeed,
      FrameCustomizationFields.iso,
    ],
  );

  static const _polaroid = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.dateTime,
      FrameCustomizationFields.camera,
    ],
  );

  static const _editorial = FrameCustomizationSpec(
    metadataFields: [
      FrameCustomizationFields.camera,
      FrameCustomizationFields.focalLength,
      FrameCustomizationFields.aperture,
      FrameCustomizationFields.shutterSpeed,
      FrameCustomizationFields.iso,
    ],
  );

  static FrameCustomizationSpec forStyle(FrameStyleId styleId) {
    return switch (styleId) {
      FrameStyleId.classic => _classic,
      FrameStyleId.darkroom => _darkroom,
      FrameStyleId.filmBorder => _filmBorder,
      FrameStyleId.minimalLine => _minimalLine,
      FrameStyleId.fujifilmSim => _fujifilmSim,
      FrameStyleId.architect => _architect,
      FrameStyleId.polaroid => _polaroid,
      FrameStyleId.editorial => _editorial,
    };
  }
}
