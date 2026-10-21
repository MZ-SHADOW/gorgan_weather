import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/widgets/cards/info_card_static.dart';

class PressureCard extends StatelessWidget {
  final WeatherModel weather;

  const PressureCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // DAILY WEATHER FROM API

    final daily = weather.daily;

    // تعداد روزها
    final int dayCount = [
      daily.time.length,
      daily.temperature2mMin.length,
      daily.temperature2mMax.length,
    ].reduce((a, b) => a < b ? a : b);
    if (dayCount == 0) {
      return InfoCardStatic(
        height: 330,
        child: const Center(
          child: Text(
            'اطلاعات روزانه موجود نیست',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    // FIND GLOBAL MIN / MAX TEMPERATURE

    final allMinTemps = daily.temperature2mMin.take(dayCount).toList();

    final allMaxTemps = daily.temperature2mMax.take(dayCount).toList();

    final double lowestTemperature = allMinTemps.reduce(
      (a, b) => a < b ? a : b,
    );

    final double highestTemperature = allMaxTemps.reduce(
      (a, b) => a > b ? a : b,
    );

    // CARD

    return InfoCardStatic(
      height: 330,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

        child: ListView.builder(
          itemCount: dayCount,

          physics: const NeverScrollableScrollPhysics(),

          padding: EdgeInsets.zero,

          itemBuilder: (context, index) {
            // TEMPERATURE

            final double minTemp = daily.temperature2mMin[index];

            final double maxTemp = daily.temperature2mMax[index];

            // DAY

            final String day = _getDayName(daily.time[index], index);

            // WEATHER CODE

            final int? weatherCode = _getWeatherCode(daily, index);

            // ICON

            final IconData icon = _weatherIcon(weatherCode);

            // TEMPERATURE BAR POSITION

            final double widthFactor = _calculateTemperaturePosition(
              minTemp: minTemp,
              maxTemp: maxTemp,
              globalMin: lowestTemperature,
              globalMax: highestTemperature,
            );

            return SizedBox(
              height: 42,

              child: Row(
                children: [
                  // DAY
                  SizedBox(
                    width: screenWidth * 0.16,

                    child: Text(
                      day,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(fontSize: screenWidth * 0.034),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // WEATHER ICON
                  SizedBox(
                    width: 30,

                    child: Icon(icon, size: screenWidth * 0.065),
                  ),

                  const SizedBox(width: 10),

                  // REMAINING SPACE
                  Expanded(
                    child: Row(
                      children: [
                        // LOW TEMPERATURE
                        SizedBox(
                          width: 32,

                          child: Text(
                            '${minTemp.round()}°',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(fontSize: screenWidth * 0.032),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // TEMPERATURE BAR
                        Expanded(
                          child: Container(
                            height: 7,

                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.25),

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,

                              widthFactor: widthFactor,

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                  gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.orange],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // HIGH TEMPERATURE
                        SizedBox(
                          width: 32,

                          child: Text(
                            '${maxTemp.round()}°',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: screenWidth * 0.032,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // CALCULATE TEMPERATURE BAR POSITION

  double _calculateTemperaturePosition({
    required double minTemp,
    required double maxTemp,
    required double globalMin,
    required double globalMax,
  }) {
    // اگر تمام دماها تقریباً برابر بودند

    if (globalMax == globalMin) {
      return 0.5;
    }

    // میانگین دمای آن روز

    final double averageTemp = (minTemp + maxTemp) / 2;

    // تبدیل دما به مقدار 0 تا 1

    final double position = (averageTemp - globalMin) / (globalMax - globalMin);

    // جلوگیری از خارج شدن از محدوده

    return position.clamp(0.05, 1.0);
  }

  // DAY NAME

  String _getDayName(String date, int index) {
    final DateTime? parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return index == 0 ? 'امروز' : 'روز ${index + 1}';
    }

    // روز اول
    if (index == 0) {
      return 'امروز';
    }

    // روز دوم
    if (index == 1) {
      return 'فردا';
    }

    switch (parsedDate.weekday) {
      case DateTime.saturday:
        return 'شنبه';

      case DateTime.sunday:
        return 'یکشنبه';

      case DateTime.monday:
        return 'دوشنبه';

      case DateTime.tuesday:
        return 'سه‌شنبه';

      case DateTime.wednesday:
        return 'چهارشنبه';

      case DateTime.thursday:
        return 'پنجشنبه';

      case DateTime.friday:
        return 'جمعه';

      default:
        return 'روز ${index + 1}';
    }
  }

  // DAILY WEATHER CODE

  int? _getWeatherCode(DailyWeather daily, int index) {
    return null;
  }

  // WEATHER CODE → ICON

  IconData _weatherIcon(int? code) {
    if (code == null) {
      return Icons.cloud_outlined;
    }

    switch (code) {
      case 0:
        return Icons.wb_sunny_outlined;

      case 1:
        return Icons.wb_sunny_outlined;

      case 2:
        return Icons.cloud_queue;

      case 3:
        return Icons.cloud;

      case 45:
      case 48:
        return Icons.foggy;

      case 51:
      case 53:
      case 55:
        return Icons.grain;

      case 56:
      case 57:
        return Icons.ac_unit;

      case 61:
      case 63:
      case 65:
        return Icons.water_drop_outlined;

      case 66:
      case 67:
        return Icons.ac_unit;

      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit;

      case 80:
      case 81:
      case 82:
        return Icons.water_drop_outlined;

      case 85:
      case 86:
        return Icons.ac_unit;

      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_outlined;

      default:
        return Icons.cloud_outlined;
    }
  }
}
