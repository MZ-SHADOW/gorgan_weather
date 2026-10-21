import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gorgan_weather/models/weather_model.dart';

class WeatherService {
  // DIO

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  // WEATHER PARAMETERS

  static const String currentVariables =
      'is_day,'
      'precipitation,'
      'pressure_msl,'
      'surface_pressure,'
      'wind_speed_10m,'
      'wind_direction_10m,'
      'wind_gusts_10m,'
      'temperature_2m,'
      'relative_humidity_2m,'
      'apparent_temperature,'
      'rain,'
      'showers,'
      'snowfall,'
      'weather_code,'
      'cloud_cover';

  static const String hourlyVariables =
      'temperature_2m,'
      'relative_humidity_2m,'
      'apparent_temperature,'
      'rain,'
      'showers,'
      'snowfall,'
      'weather_code,'
      'cloud_cover,'
      'wind_direction_10m,'
      'precipitation_probability,'
      'precipitation,'
      'visibility,'
      'pressure_msl,'
      'wind_speed_10m,'
      'wind_gusts_10m';

  static const String dailyVariables =
      'temperature_2m_max,'
      'temperature_2m_min,'
      'apparent_temperature_max,'
      'apparent_temperature_min,'
      'precipitation_hours,'
      'precipitation_sum,'
      'rain_sum,'
      'showers_sum,'
      'snowfall_sum,'
      'wind_gusts_10m_max,'
      'wind_speed_10m_max,'
      'wind_direction_10m_dominant,'
      'weather_code,'
      'sunset,'
      'sunrise';

  // GET WEATHER BY CITY

  Future<WeatherModel> getWeather(String city) async {
    final searchCity = city.trim();

    if (searchCity.isEmpty) {
      throw Exception('City name cannot be empty');
    }

    try {
      // 1. SEARCH CITY

      final geoResponse = await dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': searchCity,
          'count': 10,
          'language': 'en',
          'format': 'json',
        },
      );

      final geoData = geoResponse.data;

      if (geoData is! Map) {
        throw Exception('Invalid geocoding response');
      }

      final results = geoData['results'];

      if (results is! List || results.isEmpty) {
        throw Exception('City not found: $searchCity');
      }

      final firstResult = results.first;

      if (firstResult is! Map) {
        throw Exception('Invalid city result');
      }

      final selectedCity = Map<String, dynamic>.from(firstResult);

      // 2. COORDINATES

      final latitudeValue = selectedCity['latitude'];
      final longitudeValue = selectedCity['longitude'];

      if (latitudeValue is! num || longitudeValue is! num) {
        throw Exception('City coordinates not found');
      }

      final latitude = latitudeValue.toDouble();
      final longitude = longitudeValue.toDouble();

      // 3. CITY NAME

      final cityName =
          selectedCity['name']?.toString().trim().isNotEmpty == true
          ? selectedCity['name'].toString()
          : searchCity;

      final countryName = selectedCity['country']?.toString().trim() ?? '';

      // 4. GET WEATHER

      final weather = await _getWeatherFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      // 5. ADD CITY INFORMATION

      return weather.copyWith(cityName: cityName, countryName: countryName);
    } on DioException catch (e) {
      _printDioError(title: 'WEATHER CITY API ERROR', error: e);

      throw Exception('Unable to get weather for "$searchCity".');
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('WEATHER CITY ERROR');
      debugPrint('==========================================');
      debugPrint(e.toString());
      debugPrint('==========================================');

      throw Exception('Failed to get weather for "$searchCity": $e');
    }
  }

  // GET WEATHER BY GPS LOCATION

  Future<WeatherModel> getWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      // 1. VALIDATE GPS

      if (latitude < -90 || latitude > 90) {
        throw Exception('Invalid latitude: $latitude');
      }

      if (longitude < -180 || longitude > 180) {
        throw Exception('Invalid longitude: $longitude');
      }

      debugPrint('==========================================');
      debugPrint('GPS LOCATION');
      debugPrint('LATITUDE: $latitude');
      debugPrint('LONGITUDE: $longitude');
      debugPrint('==========================================');

      // 2. REVERSE GEOCODING

      String cityName = 'Current Location';
      String countryName = '';

      try {
        final reverseResponse = await dio.get(
          'https://nominatim.openstreetmap.org/reverse',
          queryParameters: {
            'lat': latitude,
            'lon': longitude,
            'format': 'jsonv2',
            'zoom': 10,
            'addressdetails': 1,
            'accept-language': 'en',
          },
          options: Options(
            headers: {
              'User-Agent': 'GorganWeather/1.0 (Flutter Weather Application)',
            },
          ),
        );

        final reverseData = reverseResponse.data;

        if (reverseData is Map) {
          final address = reverseData['address'];

          if (address is Map) {
            // CITY

            final possibleCity =
                address['city'] ??
                address['town'] ??
                address['municipality'] ??
                address['village'] ??
                address['county'];

            if (possibleCity != null &&
                possibleCity.toString().trim().isNotEmpty) {
              cityName = possibleCity.toString().trim();
            }

            // COUNTRY

            final possibleCountry = address['country'];

            if (possibleCountry != null &&
                possibleCountry.toString().trim().isNotEmpty) {
              countryName = possibleCountry.toString().trim();
            }
          }
        }
      } on DioException catch (e) {
        // Reverse geocoding failure must NOT stop weather API.

        debugPrint('Reverse Geocoding Error: ${e.message}');
      }

      // 3. GET WEATHER DIRECTLY FROM GPS

      final weather = await _getWeatherFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      // 4. ADD LOCATION INFORMATION

      return weather.copyWith(cityName: cityName, countryName: countryName);
    } on DioException catch (e) {
      _printDioError(title: 'GPS WEATHER API ERROR', error: e);

      throw Exception('Unable to get weather from current location.');
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('GPS WEATHER ERROR');
      debugPrint('==========================================');
      debugPrint(e.toString());
      debugPrint('==========================================');

      throw Exception('Failed to get weather from current location: $e');
    }
  }

  // PRIVATE
  // GET WEATHER FROM COORDINATES

  Future<WeatherModel> _getWeatherFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final weatherResponse = await dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        // LOCATION
        'latitude': latitude,
        'longitude': longitude,

        // CURRENT
        'current': currentVariables,

        // HOURLY
        'hourly': hourlyVariables,

        // DAILY
        'daily': dailyVariables,

        // TIMEZONE
        'timezone': 'auto',

        // FORECAST
        'forecast_days': 7,
      },
    );

    final weatherData = weatherResponse.data;

    if (weatherData is! Map) {
      throw Exception('Invalid weather API response');
    }

    return WeatherModel.fromJson(Map<String, dynamic>.from(weatherData));
  }

  // DIO ERROR LOGGER

  void _printDioError({required String title, required DioException error}) {
    debugPrint('==========================================');
    debugPrint(title);
    debugPrint('==========================================');
    debugPrint('TYPE: ${error.type}');
    debugPrint('MESSAGE: ${error.message}');
    debugPrint('STATUS: ${error.response?.statusCode}');
    debugPrint('RESPONSE: ${error.response?.data}');
    debugPrint('==========================================');
  }
}
