import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/widgets/cards/info_card_static.dart';

class HumidityCard extends StatelessWidget {
  final WeatherModel weather;

  const HumidityCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    // TODAY

    final double? maxTemp = daily.temperature2mMax.isNotEmpty
        ? daily.temperature2mMax.first
        : null;

    final double? minTemp = daily.temperature2mMin.isNotEmpty
        ? daily.temperature2mMin.first
        : null;

    // Weather code for today
    final int? weatherCode = daily.weatherCode.isNotEmpty
        ? daily.weatherCode.first
        : null;

    // WEATHER ICON

    final IconData weatherIcon = _weatherConditionIcon(weatherCode);

    // CARD

    return InfoCardStatic(
      height: 80,
      child: Row(
        children: [
          // MAX TEMPERATURE
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('گرم ترین حالت'),

                    const SizedBox(height: 7),

                    Text(maxTemp != null ? '${maxTemp.round()}°C' : '--'),
                  ],
                ),

                const SizedBox(width: 30),

                Icon(weatherIcon),
              ],
            ),
          ),

          // DIVIDER
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: VerticalDivider(thickness: 1.5),
          ),

          // MIN TEMPERATURE
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('سرد ترین حالت'),

                    const SizedBox(height: 7),

                    Text(minTemp != null ? '${minTemp.round()}°C' : '--'),
                  ],
                ),

                const SizedBox(width: 30),

                Icon(weatherIcon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WEATHER CODE → IC

  IconData _weatherConditionIcon(int? code) {
    switch (code) {
      // CLEAR SKY

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
        return Icons.grain;

      // FREEZING DRIZZLE

      case 56:
      case 57:
        return Icons.ac_unit;

      // RAIN

      case 61:
      case 63:
      case 65:
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
        return Icons.ac_unit;

      // RAIN SHOWERS

      case 80:
      case 81:
      case 82:
        return Icons.water_drop_outlined;

      // SNOW SHOWERS

      case 85:
      case 86:
        return Icons.ac_unit;

      // THUNDERSTORM

      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_outlined;

      // NULL / UNKNOWN

      default:
        return Icons.cloud_outlined;
    }
  }
}
