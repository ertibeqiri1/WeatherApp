import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../services/weather_api_service.dart';
import '../core/exceptions.dart';

// ------------------------------------------------------------------
// Abstract interface — ViewModels depend on this, never on the impl.
// ------------------------------------------------------------------
abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String city);
  Future<List<HourlyForecastModel>> getHourlyForecast(String city);
  Future<List<DailyForecastModel>> getDailyForecast(String city);
}

// ------------------------------------------------------------------
// Concrete implementation
// ------------------------------------------------------------------
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;
  final SharedPreferences _prefs;

  static const String _keyCurrentWeather = 'cached_current_weather';
  static const String _keyLastFetchTime = 'cached_last_fetch_time';
  static const Duration _cacheDuration = Duration(minutes: 30);

  WeatherRepositoryImpl({
    required WeatherApiService apiService,
    required SharedPreferences prefs,
  })  : _apiService = apiService,
        _prefs = prefs;

  // ----------------------------------------------------------------
  // Current weather — serves from cache if still fresh
  // ----------------------------------------------------------------
  @override
  Future<Weather> getCurrentWeather(String city) async {
    try {
      if (_isCacheValid()) {
        final cached = _prefs.getString(_keyCurrentWeather);
        if (cached != null) {
          return Weather.fromJson(jsonDecode(cached) as Map<String, dynamic>);
        }
      }

      final weather = await _apiService.fetchCurrentWeather(city);

      _prefs.setString(_keyCurrentWeather, jsonEncode(weather.toJson()));
      _prefs.setInt(_keyLastFetchTime, DateTime.now().millisecondsSinceEpoch);

      return weather;
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherRepositoryException('Failed to load current weather: $e');
    }
  }

  // ----------------------------------------------------------------
  // Hourly forecast — always fresh, no cache needed
  // ----------------------------------------------------------------
  @override
  Future<List<HourlyForecastModel>> getHourlyForecast(String city) async {
    try {
      return await _apiService.fetchHourlyForecast(city);
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherRepositoryException('Failed to load hourly forecast: $e');
    }
  }

  // ----------------------------------------------------------------
  // Daily forecast — always fresh, no cache needed
  // ----------------------------------------------------------------
  @override
  Future<List<DailyForecastModel>> getDailyForecast(String city) async {
    try {
      return await _apiService.fetchDailyForecast(city);
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherRepositoryException('Failed to load daily forecast: $e');
    }
  }

  // ----------------------------------------------------------------
  // Cache helpers
  // ----------------------------------------------------------------
  bool _isCacheValid() {
    final lastFetch = _prefs.getInt(_keyLastFetchTime);
    if (lastFetch == null) return false;
    final age = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastFetch));
    return age < _cacheDuration;
  }
}
