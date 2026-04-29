import 'package:flutter/foundation.dart';

import '../models/weather_model.dart';
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
  WeatherModel? _currentWeather;
  List<HourlyForecastModel> _hourlyForecast = [];
  List<DailyForecastModel> _dailyForecast = [];
  String _errorMessage = '';

  WeatherStatus get status => _status;
  WeatherModel? get currentWeather => _currentWeather;
  List<HourlyForecastModel> get hourlyForecast => _hourlyForecast;
  List<DailyForecastModel> get dailyForecast => _dailyForecast;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _status == WeatherStatus.success;

  Future<void> loadWeather(String city) async {
    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCurrentWeather(city),
        _repository.getHourlyForecast(city),
        _repository.getDailyForecast(city),
      ]);

      _currentWeather = results[0] as WeatherModel;
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

  void clearError() {
    _errorMessage = '';
    _status = WeatherStatus.initial;
    notifyListeners();
  }
}
