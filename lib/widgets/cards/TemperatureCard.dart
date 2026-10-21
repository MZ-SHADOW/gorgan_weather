import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/widgets/cards/info_card_static.dart';

class Temperaturecard extends StatelessWidget {
  final WeatherModel weather;

  const Temperaturecard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;

    // CURRENT WEATHER DATA

    final double currentTemp = current.temperature2m;

    final double feelsLike = current.apparentTemperature;

    final int weatherCode = current.weatherCode;

    // WEATHER CONDITION

    final String conditionText = weatherConditionText(weatherCode);

    final IconData conditionIcon = weatherConditionIcon(weatherCode);

    // LOCATION

    final String cityName = weather.cityName;

    return SizedBox(
      width: double.infinity,
      height: 180,
      child: InfoCardStatic(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOCATION + WEATHER ICON
              SizedBox(
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // LOCATION
                    Positioned(
                      left: -10,
                      right: 90,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 25),

                          const SizedBox(width: 4),

                          Flexible(
                            child: Text(
                              cityName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // WEATHER ICON
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(conditionIcon, size: 150),
                    ),
                  ],
                ),
              ),

              // CURRENT TEMPERATURE + CONDITION
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TEMPERATURE
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 15),
                    child: Text(
                      '${currentTemp.round()}°',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // CONDITION
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        conditionText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // FEELS LIKE
              Text(
                'Feels like ${feelsLike.round()}°',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WEATHER CODE → TEXT

String weatherConditionText(int code) {
  switch (code) {
    case 0:
      return 'Clear sky';

    case 1:
      return 'Mainly clear';

    case 2:
      return 'Partly cloudy';

    case 3:
      return 'Overcast';

    case 45:
    case 48:
      return 'Fog';

    case 51:
    case 53:
    case 55:
      return 'Drizzle';

    case 56:
    case 57:
      return 'Freezing drizzle';

    case 61:
    case 63:
    case 65:
      return 'Rain';

    case 66:
    case 67:
      return 'Freezing rain';

    case 71:
    case 73:
    case 75:
    case 77:
      return 'Snow';

    case 80:
    case 81:
    case 82:
      return 'Rain showers';

    case 85:
    case 86:
      return 'Snow showers';

    case 95:
      return 'Thunderstorm';

    case 96:
    case 99:
      return 'Thunderstorm with hail';

    default:
      return 'Unknown';
  }
}

// WEATHER CODE → ICON

IconData weatherConditionIcon(int code) {
  switch (code) {
    // CLEAR

    case 0:
      return Icons.wb_sunny_outlined;

    // MAINLY CLEAR

    case 1:
      return Icons.wb_sunny_outlined;

    // PARTLY CLOUDY

    case 2:
      return Icons.cloud_queue;

    // OVERCAST

    case 3:
      return Icons.cloud;

    // FOG

    case 45:
    case 48:
      return Icons.foggy;

    // DRIZZLE

    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return Icons.grain;

    // RAIN

    case 61:
    case 63:
    case 65:
    case 80:
    case 81:
    case 82:
      return Icons.water_drop_outlined;

    // FREEZING RAIN

    case 66:
    case 67:
      return Icons.ac_unit;

    // SNOW

    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return Icons.ac_unit;

    // THUNDERSTORM

    case 95:
    case 96:
    case 99:
      return Icons.thunderstorm_outlined;

    // UNKNOWN

    default:
      return Icons.cloud_outlined;
  }
}
