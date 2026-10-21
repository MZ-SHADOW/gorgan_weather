import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';

import 'info_card_static.dart';

class WindDirectionCard extends StatelessWidget {
  final WeatherModel weather;

  const WindDirectionCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    // TODAY

    final String? sunrise = daily.sunrise.isNotEmpty
        ? daily.sunrise.first
        : null;

    final String? sunset = daily.sunset.isNotEmpty ? daily.sunset.first : null;

    // FORMAT TIME

    final String sunriseTime = _formatTime(sunrise);

    final String sunsetTime = _formatTime(sunset);

    // ICON

    final IconData sunriseIcon = _sunriseIcon(sunrise);

    final IconData sunsetIcon = _sunsetIcon(sunset);

    return InfoCardStatic(
      height: 90,
      child: Directionality(
        textDirection: TextDirection.rtl,

        child: Row(
          children: [
            // MOON
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'مجله ماه',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'هلال',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.nightlight_round, size: 28),
                ],
              ),
            ),

            // DIVIDER
            Container(width: 1, height: 75, color: const Color(0xffe6b6b6)),

            // SUNSET
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'غروب آفتاب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        sunsetTime,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  Icon(sunsetIcon, size: 28, color: const Color(0xffff8f00)),
                ],
              ),
            ),

            // SUNRISE
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'طلوع آفتاب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        sunriseTime,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  Icon(sunriseIcon, size: 28, color: const Color(0xffffb300)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FORMAT API DATETIME

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) {
      return '--:--';
    }

    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return '--:--';
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');

    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // SUNRISE ICON

  IconData _sunriseIcon(String? value) {
    if (value == null || value.isEmpty) {
      return Icons.wb_sunny_outlined;
    }

    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return Icons.wb_sunny_outlined;
    }

    return Icons.wb_sunny_outlined;
  }

  // SUNSET ICON

  IconData _sunsetIcon(String? value) {
    if (value == null || value.isEmpty) {
      return Icons.wb_sunny_outlined;
    }

    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return Icons.wb_sunny_outlined;
    }

    return Icons.wb_twilight;
  }
}
