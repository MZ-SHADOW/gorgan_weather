class WeatherModel {
  // موقعیت مکانی

  final String cityName;

  final String countryName;

  // اطلاعات عمومی

  final double latitude;

  final double longitude;

  final double generationtimeMs;

  final int utcOffsetSeconds;

  final String timezone;

  final String timezoneAbbreviation;

  final double elevation;

  // وضعیت فعلی

  final CurrentUnits currentUnits;

  final CurrentWeather current;

  // وضعیت ساعتی

  final HourlyUnits hourlyUnits;

  final HourlyWeather hourly;

  // وضعیت روزانه

  final DailyUnits dailyUnits;

  final DailyWeather daily;

  // سازنده

  const WeatherModel({
    required this.cityName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.currentUnits,
    required this.current,
    required this.hourlyUnits,
    required this.hourly,
    required this.dailyUnits,
    required this.daily,
  });

  // تبدیل از JSON

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      // نام شهر توسط API پیش‌بینی آب‌وهوا Open-Meteo برگردانده نمی‌شود.
      // WeatherService این مقادیر را با استفاده از API موقعیت‌یابی تکمیل می‌کند.
      cityName: '',
      countryName: '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
      utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
      timezone: json['timezone'].toString(),
      timezoneAbbreviation: json['timezone_abbreviation'].toString(),
      elevation: (json['elevation'] as num).toDouble(),
      currentUnits: CurrentUnits.fromJson(
        json['current_units'] as Map<String, dynamic>,
      ),
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourlyUnits: HourlyUnits.fromJson(
        json['hourly_units'] as Map<String, dynamic>,
      ),
      hourly: HourlyWeather.fromJson(json['hourly'] as Map<String, dynamic>),
      dailyUnits: DailyUnits.fromJson(
        json['daily_units'] as Map<String, dynamic>,
      ),
      daily: DailyWeather.fromJson(json['daily'] as Map<String, dynamic>),
    );
  }

  // ایجاد یک نسخه جدید با مقادیر تغییرکرده

  WeatherModel copyWith({String? cityName, String? countryName}) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      latitude: latitude,
      longitude: longitude,
      generationtimeMs: generationtimeMs,
      utcOffsetSeconds: utcOffsetSeconds,
      timezone: timezone,
      timezoneAbbreviation: timezoneAbbreviation,
      elevation: elevation,
      currentUnits: currentUnits,
      current: current,
      hourlyUnits: hourlyUnits,
      hourly: hourly,
      dailyUnits: dailyUnits,
      daily: daily,
    );
  }

  // تبدیل به JSON

  Map<String, dynamic> toJson() {
    return {
      'city_name': cityName,
      'country_name': countryName,
      'latitude': latitude,
      'longitude': longitude,
      'generationtime_ms': generationtimeMs,
      'utc_offset_seconds': utcOffsetSeconds,
      'timezone': timezone,
      'timezone_abbreviation': timezoneAbbreviation,
      'elevation': elevation,
      'current_units': currentUnits.toJson(),
      'current': current.toJson(),
      'hourly_units': hourlyUnits.toJson(),
      'hourly': hourly.toJson(),
      'daily_units': dailyUnits.toJson(),
      'daily': daily.toJson(),
    };
  }
}

// واحدهای وضعیت فعلی

class CurrentUnits {
  final String time;

  final String interval;

  final String isDay;

  final String precipitation;

  final String pressureMsl;

  final String surfacePressure;

  final String windSpeed10m;

  final String windDirection10m;

  final String windGusts10m;

  final String temperature2m;

  final String relativeHumidity2m;

  final String apparentTemperature;

  final String rain;

  final String showers;

  final String snowfall;

  final String weatherCode;

  final String cloudCover;

  const CurrentUnits({
    required this.time,
    required this.interval,
    required this.isDay,
    required this.precipitation,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.windSpeed10m,
    required this.windDirection10m,
    required this.windGusts10m,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) {
    return CurrentUnits(
      time: json['time'].toString(),
      interval: json['interval'].toString(),
      isDay: json['is_day'].toString(),
      precipitation: json['precipitation'].toString(),
      pressureMsl: json['pressure_msl'].toString(),
      surfacePressure: json['surface_pressure'].toString(),
      windSpeed10m: json['wind_speed_10m'].toString(),
      windDirection10m: json['wind_direction_10m'].toString(),
      windGusts10m: json['wind_gusts_10m'].toString(),
      temperature2m: json['temperature_2m'].toString(),
      relativeHumidity2m: json['relative_humidity_2m'].toString(),
      apparentTemperature: json['apparent_temperature'].toString(),
      rain: json['rain'].toString(),
      showers: json['showers'].toString(),
      snowfall: json['snowfall'].toString(),
      weatherCode: json['weather_code'].toString(),
      cloudCover: json['cloud_cover'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'interval': interval,
      'is_day': isDay,
      'precipitation': precipitation,
      'pressure_msl': pressureMsl,
      'surface_pressure': surfacePressure,
      'wind_speed_10m': windSpeed10m,
      'wind_direction_10m': windDirection10m,
      'wind_gusts_10m': windGusts10m,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
    };
  }
}

// وضعیت آب‌وهوای فعلی

class CurrentWeather {
  final String time;

  final int interval;

  final int isDay;

  final double precipitation;

  final double pressureMsl;

  final double surfacePressure;

  final double windSpeed10m;

  final int windDirection10m;

  final double windGusts10m;

  final double temperature2m;

  final int relativeHumidity2m;

  final double apparentTemperature;

  final double rain;

  final double showers;

  final double snowfall;

  final int weatherCode;

  final int cloudCover;

  const CurrentWeather({
    required this.time,
    required this.interval,
    required this.isDay,
    required this.precipitation,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.windSpeed10m,
    required this.windDirection10m,
    required this.windGusts10m,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'].toString(),
      interval: (json['interval'] as num).toInt(),
      isDay: (json['is_day'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      pressureMsl: (json['pressure_msl'] as num).toDouble(),
      surfacePressure: (json['surface_pressure'] as num).toDouble(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
      windDirection10m: (json['wind_direction_10m'] as num).toInt(),
      windGusts10m: (json['wind_gusts_10m'] as num).toDouble(),
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity2m: (json['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      rain: (json['rain'] as num).toDouble(),
      showers: (json['showers'] as num).toDouble(),
      snowfall: (json['snowfall'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      cloudCover: (json['cloud_cover'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'interval': interval,
      'is_day': isDay,
      'precipitation': precipitation,
      'pressure_msl': pressureMsl,
      'surface_pressure': surfacePressure,
      'wind_speed_10m': windSpeed10m,
      'wind_direction_10m': windDirection10m,
      'wind_gusts_10m': windGusts10m,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
    };
  }
}

// واحدهای وضعیت ساعتی

class HourlyUnits {
  final String time;

  final String temperature2m;

  final String relativeHumidity2m;

  final String apparentTemperature;

  final String rain;

  final String showers;

  final String snowfall;

  final String weatherCode;

  final String cloudCover;

  final String windDirection10m;

  final String precipitationProbability;

  final String precipitation;

  final String visibility;

  final String pressureMsl;

  final String windSpeed10m;

  final String windGusts10m;

  const HourlyUnits({
    required this.time,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
    required this.windDirection10m,
    required this.precipitationProbability,
    required this.precipitation,
    required this.visibility,
    required this.pressureMsl,
    required this.windSpeed10m,
    required this.windGusts10m,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(
      time: json['time'].toString(),
      temperature2m: json['temperature_2m'].toString(),
      relativeHumidity2m: json['relative_humidity_2m'].toString(),
      apparentTemperature: json['apparent_temperature'].toString(),
      rain: json['rain'].toString(),
      showers: json['showers'].toString(),
      snowfall: json['snowfall'].toString(),
      weatherCode: json['weather_code'].toString(),
      cloudCover: json['cloud_cover'].toString(),
      windDirection10m: json['wind_direction_10m'].toString(),
      precipitationProbability: json['precipitation_probability'].toString(),
      precipitation: json['precipitation'].toString(),
      visibility: json['visibility'].toString(),
      pressureMsl: json['pressure_msl'].toString(),
      windSpeed10m: json['wind_speed_10m'].toString(),
      windGusts10m: json['wind_gusts_10m'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
      'wind_direction_10m': windDirection10m,
      'precipitation_probability': precipitationProbability,
      'precipitation': precipitation,
      'visibility': visibility,
      'pressure_msl': pressureMsl,
      'wind_speed_10m': windSpeed10m,
      'wind_gusts_10m': windGusts10m,
    };
  }
}

// وضعیت آب‌وهوای ساعتی

class HourlyWeather {
  final List<String> time;

  final List<double> temperature2m;

  final List<int> relativeHumidity2m;

  final List<double> apparentTemperature;

  final List<double> rain;

  final List<double> showers;

  final List<double> snowfall;

  final List<int> weatherCode;

  final List<int> cloudCover;

  final List<int> windDirection10m;

  final List<int> precipitationProbability;

  final List<double> precipitation;

  final List<double> visibility;

  final List<double> pressureMsl;

  final List<double> windSpeed10m;

  final List<double> windGusts10m;

  const HourlyWeather({
    required this.time,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
    required this.windDirection10m,
    required this.precipitationProbability,
    required this.precipitation,
    required this.visibility,
    required this.pressureMsl,
    required this.windSpeed10m,
    required this.windGusts10m,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: (json['time'] as List).map((e) => e.toString()).toList(),
      temperature2m: (json['temperature_2m'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      relativeHumidity2m: (json['relative_humidity_2m'] as List)
          .map((e) => (e as num).toInt())
          .toList(),
      apparentTemperature: (json['apparent_temperature'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      rain: (json['rain'] as List).map((e) => (e as num).toDouble()).toList(),
      showers: (json['showers'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      snowfall: (json['snowfall'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      weatherCode: (json['weather_code'] as List)
          .map((e) => (e as num).toInt())
          .toList(),
      cloudCover: (json['cloud_cover'] as List)
          .map((e) => (e as num).toInt())
          .toList(),
      windDirection10m: (json['wind_direction_10m'] as List)
          .map((e) => (e as num).toInt())
          .toList(),
      precipitationProbability: (json['precipitation_probability'] as List)
          .map((e) => (e as num).toInt())
          .toList(),
      precipitation: (json['precipitation'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      visibility: (json['visibility'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      pressureMsl: (json['pressure_msl'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      windSpeed10m: (json['wind_speed_10m'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      windGusts10m: (json['wind_gusts_10m'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'rain': rain,
      'showers': showers,
      'snowfall': snowfall,
      'weather_code': weatherCode,
      'cloud_cover': cloudCover,
      'wind_direction_10m': windDirection10m,
      'precipitation_probability': precipitationProbability,
      'precipitation': precipitation,
      'visibility': visibility,
      'pressure_msl': pressureMsl,
      'wind_speed_10m': windSpeed10m,
      'wind_gusts_10m': windGusts10m,
    };
  }
}

// واحدهای وضعیت روزانه

class DailyUnits {
  final String time;

  final String temperature2mMax;

  final String temperature2mMin;

  final String apparentTemperatureMax;

  final String apparentTemperatureMin;

  final String precipitationHours;

  final String precipitationSum;

  final String rainSum;

  final String showersSum;

  final String snowfallSum;

  final String windGusts10mMax;

  final String windSpeed10mMax;

  final String windDirection10mDominant;

  final String sunset;

  final String sunrise;

  const DailyUnits({
    required this.time,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.precipitationHours,
    required this.precipitationSum,
    required this.rainSum,
    required this.showersSum,
    required this.snowfallSum,
    required this.windGusts10mMax,
    required this.windSpeed10mMax,
    required this.windDirection10mDominant,
    required this.sunset,
    required this.sunrise,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) {
    return DailyUnits(
      time: json['time'].toString(),
      temperature2mMax: json['temperature_2m_max'].toString(),
      temperature2mMin: json['temperature_2m_min'].toString(),
      apparentTemperatureMax: json['apparent_temperature_max'].toString(),
      apparentTemperatureMin: json['apparent_temperature_min'].toString(),
      precipitationHours: json['precipitation_hours'].toString(),
      precipitationSum: json['precipitation_sum'].toString(),
      rainSum: json['rain_sum'].toString(),
      showersSum: json['showers_sum'].toString(),
      snowfallSum: json['snowfall_sum'].toString(),
      windGusts10mMax: json['wind_gusts_10m_max'].toString(),
      windSpeed10mMax: json['wind_speed_10m_max'].toString(),
      windDirection10mDominant: json['wind_direction_10m_dominant'].toString(),
      sunset: json['sunset'].toString(),
      sunrise: json['sunrise'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'apparent_temperature_max': apparentTemperatureMax,
      'apparent_temperature_min': apparentTemperatureMin,
      'precipitation_hours': precipitationHours,
      'precipitation_sum': precipitationSum,
      'rain_sum': rainSum,
      'showers_sum': showersSum,
      'snowfall_sum': snowfallSum,
      'wind_gusts_10m_max': windGusts10mMax,
      'wind_speed_10m_max': windSpeed10mMax,
      'wind_direction_10m_dominant': windDirection10mDominant,
      'sunset': sunset,
      'sunrise': sunrise,
    };
  }
}

// وضعیت آب‌وهوای روزانه

class DailyWeather {
  final List<String> time;

  final List<double> temperature2mMax;

  final List<double> temperature2mMin;

  final List<double> apparentTemperatureMax;

  final List<double> apparentTemperatureMin;

  final List<double> precipitationHours;

  final List<double> precipitationSum;

  final List<double> rainSum;

  final List<double> showersSum;

  final List<double> snowfallSum;

  final List<double> windGusts10mMax;

  final List<double> windSpeed10mMax;

  final List<int> windDirection10mDominant;

  final List<int> weatherCode;

  final List<String> sunset;

  final List<String> sunrise;

  const DailyWeather({
    required this.time,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.precipitationHours,
    required this.precipitationSum,
    required this.rainSum,
    required this.showersSum,
    required this.snowfallSum,
    required this.windGusts10mMax,
    required this.windSpeed10mMax,
    required this.windDirection10mDominant,
    required this.weatherCode,
    required this.sunset,
    required this.sunrise,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      time: (json['time'] as List).map((e) => e.toString()).toList(),
      temperature2mMax: (json['temperature_2m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      temperature2mMin: (json['temperature_2m_min'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      apparentTemperatureMax: (json['apparent_temperature_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      apparentTemperatureMin: (json['apparent_temperature_min'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      precipitationHours: (json['precipitation_hours'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      precipitationSum: (json['precipitation_sum'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      rainSum: (json['rain_sum'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      showersSum: (json['showers_sum'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      snowfallSum: (json['snowfall_sum'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      windGusts10mMax: (json['wind_gusts_10m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      windSpeed10mMax: (json['wind_speed_10m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      windDirection10mDominant: (json['wind_direction_10m_dominant'] as List)
          .map((e) => (e as num).toInt())
          .toList(),

      // مهم
      weatherCode: (json['weather_code'] as List)
          .map((e) => (e as num).toInt())
          .toList(),

      sunset: (json['sunset'] as List).map((e) => e.toString()).toList(),
      sunrise: (json['sunrise'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'apparent_temperature_max': apparentTemperatureMax,
      'apparent_temperature_min': apparentTemperatureMin,
      'precipitation_hours': precipitationHours,
      'precipitation_sum': precipitationSum,
      'rain_sum': rainSum,
      'showers_sum': showersSum,
      'snowfall_sum': snowfallSum,
      'wind_gusts_10m_max': windGusts10mMax,
      'wind_speed_10m_max': windSpeed10mMax,
      'wind_direction_10m_dominant': windDirection10mDominant,
      'weather_code': weatherCode,
      'sunset': sunset,
      'sunrise': sunrise,
    };
  }
}
