class ExifData {
  const ExifData({
    this.cameraMake,
    this.cameraModel,
    this.lensModel,
    this.aperture,
    this.shutterSpeed,
    this.iso,
    this.focalLength,
    this.focalLengthEquiv,
    this.exposureCompensation,
    this.whiteBalance,
    this.dateTime,
    this.latitude,
    this.longitude,
    this.locationName,
    this.imageWidth,
    this.imageHeight,
  });

  factory ExifData.fromMap(Map<String, dynamic> map) {
    return ExifData(
      cameraMake: map['cameraMake'] as String?,
      cameraModel: map['cameraModel'] as String?,
      lensModel: map['lensModel'] as String?,
      aperture: (map['aperture'] as num?)?.toDouble(),
      shutterSpeed: map['shutterSpeed'] as String?,
      iso: map['iso'] as int?,
      focalLength: (map['focalLength'] as num?)?.toDouble(),
      focalLengthEquiv: (map['focalLengthEquiv'] as num?)?.toDouble(),
      exposureCompensation: (map['exposureCompensation'] as num?)?.toDouble(),
      whiteBalance: map['whiteBalance'] as String?,
      dateTime: map['dateTime'] != null
          ? DateTime.tryParse(map['dateTime'] as String)
          : null,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      locationName: map['locationName'] as String?,
      imageWidth: map['imageWidth'] as int?,
      imageHeight: map['imageHeight'] as int?,
    );
  }

  final String? cameraMake;
  final String? cameraModel;
  final String? lensModel;
  final double? aperture;
  final String? shutterSpeed;
  final int? iso;
  final double? focalLength;
  final double? focalLengthEquiv;
  final double? exposureCompensation;
  final String? whiteBalance;
  final DateTime? dateTime;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final int? imageWidth;
  final int? imageHeight;

  static const empty = ExifData();

  bool get isEmpty =>
      cameraMake == null &&
      cameraModel == null &&
      lensModel == null &&
      aperture == null &&
      shutterSpeed == null &&
      iso == null &&
      focalLength == null &&
      dateTime == null;

  String? get displayCameraName {
    if (cameraMake == null && cameraModel == null) {
      return null;
    }
    final make = cameraMake ?? '';
    final model = cameraModel ?? '';
    if (model.toLowerCase().startsWith(make.toLowerCase())) {
      return model;
    }
    return '$make $model'.trim();
  }

  String? get displayDimensions {
    if (imageWidth == null || imageHeight == null) {
      return null;
    }
    return '$imageWidth x $imageHeight';
  }

  ExifData copyWith({
    String? cameraMake,
    String? cameraModel,
    String? lensModel,
    double? aperture,
    String? shutterSpeed,
    int? iso,
    double? focalLength,
    double? focalLengthEquiv,
    double? exposureCompensation,
    String? whiteBalance,
    DateTime? dateTime,
    double? latitude,
    double? longitude,
    String? locationName,
    int? imageWidth,
    int? imageHeight,
  }) {
    return ExifData(
      cameraMake: cameraMake ?? this.cameraMake,
      cameraModel: cameraModel ?? this.cameraModel,
      lensModel: lensModel ?? this.lensModel,
      aperture: aperture ?? this.aperture,
      shutterSpeed: shutterSpeed ?? this.shutterSpeed,
      iso: iso ?? this.iso,
      focalLength: focalLength ?? this.focalLength,
      focalLengthEquiv: focalLengthEquiv ?? this.focalLengthEquiv,
      exposureCompensation: exposureCompensation ?? this.exposureCompensation,
      whiteBalance: whiteBalance ?? this.whiteBalance,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cameraMake': cameraMake,
      'cameraModel': cameraModel,
      'lensModel': lensModel,
      'aperture': aperture,
      'shutterSpeed': shutterSpeed,
      'iso': iso,
      'focalLength': focalLength,
      'focalLengthEquiv': focalLengthEquiv,
      'exposureCompensation': exposureCompensation,
      'whiteBalance': whiteBalance,
      'dateTime': dateTime?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExifData &&
        other.cameraMake == cameraMake &&
        other.cameraModel == cameraModel &&
        other.lensModel == lensModel &&
        other.aperture == aperture &&
        other.shutterSpeed == shutterSpeed &&
        other.iso == iso &&
        other.focalLength == focalLength &&
        other.focalLengthEquiv == focalLengthEquiv &&
        other.exposureCompensation == exposureCompensation &&
        other.whiteBalance == whiteBalance &&
        other.dateTime == dateTime &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.locationName == locationName &&
        other.imageWidth == imageWidth &&
        other.imageHeight == imageHeight;
  }

  @override
  int get hashCode => Object.hash(
    cameraMake,
    cameraModel,
    lensModel,
    aperture,
    shutterSpeed,
    iso,
    focalLength,
    focalLengthEquiv,
    exposureCompensation,
    whiteBalance,
    dateTime,
    latitude,
    longitude,
    locationName,
    imageWidth,
    imageHeight,
  );
}
