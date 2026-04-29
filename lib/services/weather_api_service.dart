// TODO (Dev — Phase 3): Replace stub with real Dio API calls

import '../models/weather_model.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
// ignore: unused_import — used in Phase 3 real implementation
import '../core/exceptions.dart';

abstract class WeatherApiService {
  Future<WeatherModel> fetchCurrentWeather(String city);
  Future<List<HourlyForecastModel>> fetchHourlyForecast(String city);
  Future<List<DailyForecastModel>> fetchDailyForecast(String city);
}

/// Stub implementation — returns dummy data until Phase 3
class WeatherApiServiceStub implements WeatherApiService {
  @override
  Future<WeatherModel> fetchCurrentWeather(String city) async {
    return WeatherModel(
      city: city,
      condition: 'Partly Cloudy',
      temperature: 26,
      high: 27,
      low: 18,
    );
  }

  @override
  Future<List<HourlyForecastModel>> fetchHourlyForecast(String city) async {
    return [
      HourlyForecastModel(time: 'Now', condition: 'Partly Cloudy', temperature: 26),
      HourlyForecastModel(time: '12:00PM', condition: 'Partly Cloudy', temperature: 27),
      HourlyForecastModel(time: '13:00PM', condition: 'Partly Cloudy', temperature: 27),
      HourlyForecastModel(time: '14:00PM', condition: 'Cloudy', temperature: 22),
      HourlyForecastModel(time: '15:00PM', condition: 'Cloudy', temperature: 22),
      HourlyForecastModel(time: '16:00PM', condition: 'Cloudy', temperature: 21),
      HourlyForecastModel(time: '17:00PM', condition: 'Sunset', temperature: 20),
      HourlyForecastModel(time: '18:00PM', condition: 'Light Rain', temperature: 18),
      HourlyForecastModel(time: '19:00PM', condition: 'Light Rain', temperature: 18),
    ];
  }

  @override
  Future<List<DailyForecastModel>> fetchDailyForecast(String city) async {
    return [
      DailyForecastModel(day: 'Today', condition: 'Partly Cloudy', high: 27, low: 18),
      DailyForecastModel(day: 'Wed', condition: 'Light Rain', high: 21, low: 14),
      DailyForecastModel(day: 'Thu', condition: 'Light Rain', high: 25, low: 12),
      DailyForecastModel(day: 'Fri', condition: 'Cloudy', high: 24, low: 17),
      DailyForecastModel(day: 'Sat', condition: 'Sunny', high: 27, low: 22),
      DailyForecastModel(day: 'Sun', condition: 'Partly Cloudy', high: 25, low: 16),
      DailyForecastModel(day: 'Mon', condition: 'Cloudy', high: 22, low: 14),
    ];
  }
}
