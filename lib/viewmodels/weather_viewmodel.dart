import 'package:flutter/foundation.dart';

import '../models/weather.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../repositories/weather_repository.dart';
import '../core/exceptions.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherViewModel({required WeatherRepository repository})
      : _repository = repository;

  WeatherStatus _status = WeatherStatus.initial;
  Weather? _currentWeather;
  List<HourlyForecastModel> _hourlyForecast = [];
  List<DailyForecastModel> _dailyForecast = [];
  String _errorMessage = '';
  int _selectedTabIndex = 0;
  String _currentCity = '';

  WeatherStatus get status => _status;
  Weather? get currentWeather => _currentWeather;
  List<HourlyForecastModel> get hourlyForecast => _hourlyForecast;
  List<DailyForecastModel> get dailyForecast => _dailyForecast;
  String get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;
  String get currentCity => _currentCity;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _status == WeatherStatus.success;

  Future<void> searchCity(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) return;
    await loadWeather(trimmed);
  }

  Future<void> loadWeather(String city) async {
    _currentCity = city;
    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCurrentWeather(city),
        _repository.getHourlyForecast(city),
        _repository.getDailyForecast(city),
      ]);

      _currentWeather = results[0] as Weather;
      _hourlyForecast = results[1] as List<HourlyForecastModel>;
      _dailyForecast = results[2] as List<DailyForecastModel>;
      _status = WeatherStatus.success;
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
      _status = WeatherStatus.error;
    } on WeatherRepositoryException catch (e) {
      _errorMessage = e.message;
      _status = WeatherStatus.error;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _status = WeatherStatus.error;
    }

    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    _status = WeatherStatus.initial;
    notifyListeners();
  }
}
