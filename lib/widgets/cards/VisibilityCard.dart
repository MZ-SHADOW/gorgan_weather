import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/widgets/cards/info_card_static.dart';

class VisibilityCard extends StatelessWidget {
  final WeatherModel weather;

  const VisibilityCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // HOURLY WEATHER

    final hourly = weather.hourly;

    if (hourly.time.isEmpty) {
      return InfoCardStatic(
        height: 120,
        width: screenWidth * 0.9,
        child: const Center(
          child: Text(
            'اطلاعات ساعتی موجود نیست',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    // FIND CURRENT HOUR

    final currentTime = DateTime.tryParse(weather.current.time);

    int startIndex = 0;

    if (currentTime != null) {
      final foundIndex = hourly.time.indexWhere((time) {
        final hourTime = DateTime.tryParse(time);

        if (hourTime == null) {
          return false;
        }

        return hourTime.year == currentTime.year &&
            hourTime.month == currentTime.month &&
            hourTime.day == currentTime.day &&
            hourTime.hour == currentTime.hour;
      });

      if (foundIndex != -1) {
        startIndex = foundIndex;
      }
    }

    // NEXT 12 HOURS

    final endIndex = (startIndex + 12).clamp(0, hourly.time.length);

    final next12Hours = List.generate(
      endIndex - startIndex,
      (index) => startIndex + index,
    );

    // CARD

    return InfoCardStatic(
      height: 120,
      width: screenWidth * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: next12Hours.map((index) {
              return _HourlyItem(
                time: hourly.time[index],
                temperature: hourly.temperature2m[index],
                weatherCode: hourly.weatherCode[index],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// HOURLY ITEM

class _HourlyItem extends StatelessWidget {
  final String time;
  final double temperature;
  final int weatherCode;

  const _HourlyItem({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  @override
  Widget build(BuildContext context) {
    // PARSE TIME

    final dateTime = DateTime.tryParse(time);

    final hourOnly = dateTime != null
        ? '${dateTime.hour.toString().padLeft(2, '0')}:00'
        : '--:--';

    // WEATHER CODE → ICON

    final icon = _weatherIcon(weatherCode);

    // UI

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TEMPERATURE
          Text(
            '${temperature.round()}°',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          // WEATHER ICON
          SizedBox(width: 32, height: 32, child: Icon(icon, size: 28)),

          const SizedBox(height: 5),

          // TIME
          Text(
            hourOnly,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // OPEN-METEO WEATHER CODE → FLUTTER ICON

  IconData _weatherIcon(int code) {
    switch (code) {
      // CLEAR SKY
      // WMO: 0

      case 0:
        return Icons.wb_sunny_outlined;

      // MAINLY CLEAR
      // WMO: 1

      case 1:
        return Icons.wb_sunny_outlined;

      // PARTLY CLOUDY
      // WMO: 2

      case 2:
        return Icons.cloud_queue;

      // OVERCAST
      // WMO: 3

      case 3:
        return Icons.cloud;

      // FOG
      // WMO: 45, 48

      case 45:
      case 48:
        return Icons.foggy;

      // DRIZZLE
      // WMO: 51, 53, 55

      case 51:
      case 53:
      case 55:
        return Icons.grain;

      // FREEZING DRIZZLE
      // WMO: 56, 57

      case 56:
      case 57:
        return Icons.ac_unit;

      // RAIN
      // WMO: 61, 63, 65

      case 61:
      case 63:
      case 65:
        return Icons.water_drop_outlined;

      // FREEZING RAIN
      // WMO: 66, 67

      case 66:
      case 67:
        return Icons.ac_unit;

      // SNOW
      // WMO: 71, 73, 75, 77

      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit;

      // RAIN SHOWERS
      // WMO: 80, 81, 82

      case 80:
      case 81:
      case 82:
        return Icons.water_drop_outlined;

      // SNOW SHOWERS
      // WMO: 85, 86

      case 85:
      case 86:
        return Icons.ac_unit;

      // THUNDERSTORM
      // WMO: 95, 96, 99

      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_outlined;

      // UNKNOWN

      default:
        return Icons.cloud_outlined;
    }
  }
}
