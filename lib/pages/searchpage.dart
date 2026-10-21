import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:gorgan_weather/models/weather_model.dart';
import 'package:gorgan_weather/service/weather_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.weatherService});

  // OPEN SEARCH PAGE

  static Future<WeatherModel?> show(
    BuildContext context, {
    required WeatherService weatherService,
  }) {
    return showModalBottomSheet<WeatherModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromARGB(213, 172, 218, 255),
      builder: (_) {
        return SearchPage(weatherService: weatherService);
      },
    );
  }

  // WEATHER SERVICE

  final WeatherService weatherService;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // CONTROLLERS

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  // DIO

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  // DEBOUNCE

  Timer? _debounce;

  // STATE

  List<Map<String, dynamic>> _suggestions = [];

  bool _isSearching = false;

  bool _isLoadingWeather = false;

  String? _errorMessage;

  // SEARCH CITY

  void _onSearchChanged(String value) {
    // CANCEL PREVIOUS DEBOUNCE

    _debounce?.cancel();

    final query = value.trim();

    // EMPTY SEARCH

    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _errorMessage = null;
      });

      return;
    }

    // DEBOUNCE

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _searchCities(query);
    });

    setState(() {
      _errorMessage = null;
    });
  }

  // SEARCH CITIES

  Future<void> _searchCities(String query) async {
    if (!mounted) return;

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final response = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': query,
          'count': 8,
          'language': 'en',
          'format': 'json',
        },
      );

      final data = response.data;

      if (data is! Map) {
        throw Exception('Invalid geocoding response');
      }

      final results = data['results'];

      if (results is! List) {
        throw Exception('Invalid city results');
      }

      final cities = results
          .whereType<Map>()
          .map((city) => Map<String, dynamic>.from(city))
          .toList();

      if (!mounted) return;

      // IMPORTANT

      if (_searchController.text.trim() != query) {
        return;
      }

      setState(() {
        _suggestions = cities;
        _isSearching = false;
      });
    } on DioException catch (e) {
      debugPrint('SEARCH API ERROR: ${e.message}');

      if (!mounted) return;

      if (_searchController.text.trim() != query) {
        return;
      }

      setState(() {
        _suggestions = [];
        _isSearching = false;
        _errorMessage = 'Unable to search cities';
      });
    } catch (e) {
      debugPrint('SEARCH ERROR: $e');

      if (!mounted) return;

      if (_searchController.text.trim() != query) {
        return;
      }

      setState(() {
        _suggestions = [];
        _isSearching = false;
        _errorMessage = 'Something went wrong';
      });
    }
  }

  // SELECT CITY

  Future<void> _selectCity(Map<String, dynamic> city) async {
    // VALIDATE COORDINATES

    final latitudeValue = city['latitude'];
    final longitudeValue = city['longitude'];

    if (latitudeValue is! num || longitudeValue is! num) {
      _showError('City coordinates are unavailable');

      return;
    }

    final latitude = latitudeValue.toDouble();
    final longitude = longitudeValue.toDouble();

    // CITY INFORMATION

    final cityName = city['name']?.toString().trim() ?? '';

    final countryName = city['country']?.toString().trim() ?? '';

    if (cityName.isEmpty) {
      _showError('City name is unavailable');

      return;
    }

    // LOADING

    setState(() {
      _isLoadingWeather = true;
    });

    // GET WEATHER

    try {
      final weather = await widget.weatherService.getWeatherByLocation(
        latitude,
        longitude,
      );

      if (!mounted) return;

      final selectedWeather = weather.copyWith(
        cityName: cityName,
        countryName: countryName,
      );

      // RETURN TO HOMEPAGE

      Navigator.pop(context, selectedWeather);
    } catch (e) {
      debugPrint('SELECT CITY WEATHER ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoadingWeather = false;
      });

      _showError('Unable to get weather for $cityName');
    }
  }

  // SHOW ERROR

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // CLEAR SEARCH

  void _clearSearch() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {
      _suggestions = [];
      _isSearching = false;
      _errorMessage = null;
    });

    _focusNode.requestFocus();
  }

  // DISPOSE

  @override
  void dispose() {
    _debounce?.cancel();

    _searchController.dispose();

    _focusNode.dispose();

    _dio.close();

    super.dispose();
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),

        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: Column(
            children: [
              // HANDLE

              const SizedBox(height: 10),

              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH FIELD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Container(
                  height: 56,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: TextField(
                    controller: _searchController,

                    focusNode: _focusNode,

                    autofocus: true,

                    onChanged: _onSearchChanged,

                    textInputAction: TextInputAction.search,

                    decoration: InputDecoration(
                      hintText: 'Search city...',

                      prefixIcon: const Icon(Icons.search),

                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),

                              onPressed: _clearSearch,
                            )
                          : null,

                      border: InputBorder.none,

                      contentPadding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CONTENT
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  // CONTENT

  Widget _buildContent() {
    // WEATHER LOADING

    if (_isLoadingWeather) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: 16),

            Text('Loading weather...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // SEARCHING

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    // ERROR

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.grey)),
      );
    }

    // EMPTY SEARCH

    if (_searchController.text.trim().isEmpty) {
      return const Center(
        child: Text('Search for a city', style: TextStyle(color: Colors.grey)),
      );
    }

    // NO RESULTS

    if (_suggestions.isEmpty) {
      return const Center(
        child: Text('No cities found', style: TextStyle(color: Colors.grey)),
      );
    }

    // RESULTS

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      itemCount: _suggestions.length,

      separatorBuilder: (_, __) {
        return const SizedBox(height: 8);
      },

      itemBuilder: (context, index) {
        final city = _suggestions[index];

        return _buildCityItem(city);
      },
    );
  }

  // CITY ITEM

  Widget _buildCityItem(Map<String, dynamic> city) {
    final name = city['name']?.toString() ?? '';

    final country = city['country']?.toString() ?? '';

    final admin1 = city['admin1']?.toString() ?? '';

    final latitude = city['latitude']?.toString() ?? '';

    final longitude = city['longitude']?.toString() ?? '';

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: _isLoadingWeather ? null : () => _selectCity(city),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.grey.shade100,

            borderRadius: BorderRadius.circular(18),
          ),

          child: Row(
            children: [
              // LOCATION ICON

              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(Icons.location_city),
              ),

              const SizedBox(width: 14),

              // CITY INFORMATION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      name,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      [
                        if (admin1.isNotEmpty) admin1,

                        if (country.isNotEmpty) country,
                      ].join(', '),

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '$latitude, $longitude',

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
