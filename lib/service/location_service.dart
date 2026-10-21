import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // 1. CHECK PERMISSION

    LocationPermission permission = await Geolocator.checkPermission();

    // 2. REQUEST PERMISSION IF NEEDED

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 3. PERMISSION DENIED

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    // 4. PERMISSION DENIED FOREVER

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    // 5. CHECK LOCATION SERVICE

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    // 6. GET CURRENT POSITION

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // CHECK IF LOCATION SERVICE IS ENABLED

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // OPEN LOCATION SETTINGS

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // OPEN APP SETTINGS

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
