import 'package:geocoding/geocoding.dart';

abstract final class GeocodeService {
  static Future<String?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final city = place.locality ?? place.subAdministrativeArea;
      final country = place.isoCountryCode ?? place.country;

      if (city == null && country == null) return null;
      if (city == null) return country;
      if (country == null) return city;
      return '$city, $country';
    } on Exception {
      return null;
    }
  }
}
