import '../../core/models/exif_data.dart';

extension ExifFormatExtensions on ExifData {
  String? get formattedAperture {
    if (aperture == null) return null;
    return 'f/${aperture!.toStringAsFixed(
      aperture! == aperture!.roundToDouble() ? 0 : 1,
    )}';
  }

  String? get formattedShutterSpeed {
    if (shutterSpeed == null) return null;
    return '${shutterSpeed}s';
  }

  String? get formattedIso {
    if (iso == null) return null;
    return 'ISO $iso';
  }

  String? get formattedFocalLength {
    if (focalLength == null) return null;
    final mm = focalLength!.round();
    if (focalLengthEquiv != null) {
      final equiv = focalLengthEquiv!.round();
      return '${mm}mm (${equiv}mm equiv.)';
    }
    return '${mm}mm';
  }

  String? get formattedExposureComp {
    if (exposureCompensation == null) return null;
    final value = exposureCompensation!;
    if (value == 0) return '±0 EV';
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)} EV';
  }

  String? get formattedDateTime {
    if (dateTime == null) return null;
    final d = dateTime!;
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.year}-$month-$day $hour:$minute';
  }

  String? get formattedWhiteBalance => whiteBalance;

  String? get formattedLocation => locationName;
}
