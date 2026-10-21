import 'package:shared_preferences/shared_preferences.dart';

class LocationStorage {
  // KEYS

  static const String _latitudeKey = 'saved_latitude';
  static const String _longitudeKey = 'saved_longitude';
  static const String _cityNameKey = 'saved_city_name';
  static const String _countryNameKey = 'saved_country_name';

  // SAVE LOCATION

  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required String cityName,
    required String countryName,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_latitudeKey, latitude);

    await prefs.setDouble(_longitudeKey, longitude);

    await prefs.setString(_cityNameKey, cityName);

    await prefs.setString(_countryNameKey, countryName);
  }

  // LOAD LOCATION

  Future<SavedLocation?> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final latitude = prefs.getDouble(_latitudeKey);

    final longitude = prefs.getDouble(_longitudeKey);

    if (latitude == null || longitude == null) {
      return null;
    }

    return SavedLocation(
      latitude: latitude,
      longitude: longitude,
      cityName: prefs.getString(_cityNameKey) ?? '',
      countryName: prefs.getString(_countryNameKey) ?? '',
    );
  }

  // CLEAR LOCATION

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
    await prefs.remove(_cityNameKey);
    await prefs.remove(_countryNameKey);
  }
}
// SAVED LOCATION MODE

class SavedLocation {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  const SavedLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });
}
