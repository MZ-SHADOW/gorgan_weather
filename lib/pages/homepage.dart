import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/pages/searchpage.dart';
import 'package:gorgan_weather/service/location_service.dart';
import 'package:gorgan_weather/service/weather_service.dart';

import 'package:gorgan_weather/widgets/appbar/weather_appbar.dart';
import 'package:gorgan_weather/widgets/cards/TemperatureCard.dart';
import 'package:gorgan_weather/widgets/cards/HumidityCard.dart';
import 'package:gorgan_weather/widgets/cards/WindSpeedCard.dart';
import 'package:gorgan_weather/widgets/cards/VisibilityCard.dart';
import 'package:gorgan_weather/widgets/cards/PressureCard.dart';
import 'package:gorgan_weather/widgets/cards/WindDirectionCard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // SERVICES

  final WeatherService weatherService = WeatherService();
  final LocationService locationService = LocationService();

  // WEATHER

  WeatherModel? weather;

  // SAVED LOCATION

  double? _savedLatitude;
  double? _savedLongitude;

  String _savedCityName = '';
  String _savedCountryName = '';

  // LOADING

  bool _isLoading = true;

  // GPS REQUEST LOCK

  bool _isRequestingLocation = false;

  // ERROR

  String? _errorMessage;

  // STORAGE KEYS

  static const String _latitudeKey = 'last_latitude';
  static const String _longitudeKey = 'last_longitude';
  static const String _cityNameKey = 'last_city_name';
  static const String _countryNameKey = 'last_country_name';

  // INIT

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  // INITIALIZE APP

  Future<void> _initializeWeather() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. LOAD SAVED LOCATION

      await _loadSavedLocation();

      // 2. IF SAVED LOCATION EXISTS
      //    USE SAVED LOCATION

      if (_savedLatitude != null && _savedLongitude != null) {
        debugPrint('==========================================');
        debugPrint('USING SAVED LOCATION');
        debugPrint('CITY: $_savedCityName');
        debugPrint('COUNTRY: $_savedCountryName');
        debugPrint('LATITUDE: $_savedLatitude');
        debugPrint('LONGITUDE: $_savedLongitude');
        debugPrint('==========================================');

        await _refreshSavedLocation();

        return;
      }

      // 3. NO SAVED LOCATION
      //    TRY GPS

      debugPrint('==========================================');
      debugPrint('NO SAVED LOCATION - TRYING GPS');
      debugPrint('==========================================');

      final success = await getWeatherFromGPS(showLoading: false);

      if (!success && mounted) {
        setState(() {
          _errorMessage ??= 'Unable to get current location.';
        });
      }
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('INITIALIZATION ERROR');
      debugPrint(e.toString());
      debugPrint('==========================================');

      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to initialize weather.';
        });
      }
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // LOAD SAVED LOCATION

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);

    final cityName = prefs.getString(_cityNameKey);
    final countryName = prefs.getString(_countryNameKey);

    if (latitude != null && longitude != null) {
      _savedLatitude = latitude;
      _savedLongitude = longitude;

      _savedCityName = cityName ?? '';
      _savedCountryName = countryName ?? '';

      debugPrint('==========================================');
      debugPrint('SAVED LOCATION FOUND');
      debugPrint('CITY: $_savedCityName');
      debugPrint('COUNTRY: $_savedCountryName');
      debugPrint('LATITUDE: $_savedLatitude');
      debugPrint('LONGITUDE: $_savedLongitude');
      debugPrint('==========================================');
    } else {
      debugPrint('==========================================');
      debugPrint('NO SAVED LOCATION');
      debugPrint('==========================================');
    }
  }

  // SAVE LOCATION

  Future<void> _saveLocation({
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

    // Update local state
    _savedLatitude = latitude;
    _savedLongitude = longitude;

    _savedCityName = cityName;
    _savedCountryName = countryName;

    debugPrint('==========================================');
    debugPrint('LOCATION SAVED');
    debugPrint('CITY: $cityName');
    debugPrint('COUNTRY: $countryName');
    debugPrint('LATITUDE: $latitude');
    debugPrint('LONGITUDE: $longitude');
    debugPrint('==========================================');
  }

  // GET WEATHER FROM GPS

  Future<bool> getWeatherFromGPS({bool showLoading = true}) async {
    if (_isRequestingLocation) {
      return false;
    }

    _isRequestingLocation = true;

    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // 1. GET CURRENT GPS LOCATION

      final position = await locationService.getCurrentLocation();

      final latitude = position.latitude;
      final longitude = position.longitude;

      debugPrint('==========================================');
      debugPrint('GPS LOCATION SUCCESS');
      debugPrint('LATITUDE: $latitude');
      debugPrint('LONGITUDE: $longitude');
      debugPrint('==========================================');

      // 2. GET WEATHER

      final result = await weatherService.getWeatherByLocation(
        latitude,
        longitude,
      );

      // 3. SAVE GPS LOCATION

      await _saveLocation(
        latitude: latitude,
        longitude: longitude,
        cityName: result.cityName,
        countryName: result.countryName,
      );

      // 4. UPDATE UI

      if (!mounted) {
        return true;
      }

      setState(() {
        weather = result;
        _errorMessage = null;
      });

      return true;
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('GPS WEATHER ERROR');
      debugPrint(e.toString());
      debugPrint('==========================================');

      final message = e.toString();

      if (message.contains('Location service is disabled')) {
        if (mounted) {
          setState(() {
            _errorMessage =
                'Location service is disabled. Please turn on your location.';
          });
        }
      } else if (message.contains('Location permission permanently denied')) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Location permission is permanently denied.';
          });
        }
      } else if (message.contains('Location permission denied')) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Location permission was denied.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Unable to get current location.';
          });
        }
      }

      return false;
    } finally {
      _isRequestingLocation = false;

      if (showLoading && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // REFRESH SAVED LOCATION

  Future<void> _refreshSavedLocation() async {
    if (_savedLatitude == null || _savedLongitude == null) {
      return;
    }

    try {
      debugPrint('==========================================');
      debugPrint('REFRESHING SAVED LOCATION');
      debugPrint('CITY: $_savedCityName');
      debugPrint('COUNTRY: $_savedCountryName');
      debugPrint('==========================================');

      final result = await weatherService.getWeatherByLocation(
        _savedLatitude!,
        _savedLongitude!,
      );

      if (!mounted) return;

      final refreshedWeather = result.copyWith(
        cityName: _savedCityName.isNotEmpty ? _savedCityName : result.cityName,
        countryName: _savedCountryName.isNotEmpty
            ? _savedCountryName
            : result.countryName,
      );

      setState(() {
        weather = refreshedWeather;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('REFRESH SAVED LOCATION ERROR');
      debugPrint(e.toString());
      debugPrint('==========================================');

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Unable to refresh saved weather.';
      });
    }
  }

  // REFRESH WEATHER

  Future<void> refreshWeather() async {
    if (_savedLatitude != null && _savedLongitude != null) {
      await _refreshSavedLocation();
      return;
    }

    await getWeatherFromGPS();
  }

  // OPEN SEARCH PAGE

  Future<void> openSearchPage() async {
    final result = await SearchPage.show(
      context,
      weatherService: weatherService,
    );

    if (result == null) {
      return;
    }

    // SAVE SELECTED CITY

    await _saveLocation(
      latitude: result.latitude,
      longitude: result.longitude,
      cityName: result.cityName,
      countryName: result.countryName,
    );

    // UPDATE CURRENT WEATHER

    if (!mounted) return;

    setState(() {
      weather = result;
      _errorMessage = null;
    });

    debugPrint('==========================================');
    debugPrint('SEARCH CITY SELECTED');
    debugPrint('CITY: ${result.cityName}');
    debugPrint('COUNTRY: ${result.countryName}');
    debugPrint('LATITUDE: ${result.latitude}');
    debugPrint('LONGITUDE: ${result.longitude}');
    debugPrint('==========================================');
  }

  // GPS BUTTON

  Future<void> _handleGpsButton() async {
    final success = await getWeatherFromGPS();

    if (success || !mounted) {
      return;
    }

    // LOCATION SERVICE DISABLED

    if (_errorMessage != null &&
        _errorMessage!.contains('Location service is disabled')) {
      await locationService.openLocationSettings();
      return;
    }

    // PERMISSION PERMANENTLY DENIED

    if (_errorMessage != null &&
        _errorMessage!.contains('permanently denied')) {
      await locationService.openAppSettings();
    }
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,

      // APP BAR
      appBar: WeatherAppbar(
        lastUpdate: weather?.current.time,

        // Search
        onSearchPressed: openSearchPage,

        // GPS
        onGpsPressed: _handleGpsButton,
      ),

      // BODY
      body: RefreshIndicator(
        onRefresh: refreshWeather,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // LOADING

                if (weather == null && _isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                // WEATHER
                else if (weather != null) ...[
                  Temperaturecard(weather: weather!),

                  HumidityCard(weather: weather!),

                  WindSpeedCard(weather: weather!),

                  VisibilityCard(weather: weather!),

                  PressureCard(weather: weather!),

                  WindDirectionCard(weather: weather!),

                  const SizedBox(height: 40),
                ]
                // ERROR
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        children: [
                          Text(
                            _errorMessage ?? 'Unable to load weather.',

                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: _initializeWeather,

                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
