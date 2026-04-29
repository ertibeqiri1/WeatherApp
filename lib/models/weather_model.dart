// TODO (Dev — Phase 2): Replace stub with full model + JSON parsing

class WeatherModel {
  final String city;
  final String condition;
  final double temperature;
  final double high;
  final double low;

  const WeatherModel({
    required this.city,
    required this.condition,
    required this.temperature,
    required this.high,
    required this.low,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'] ?? '',
      condition: json['condition'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'condition': condition,
        'temperature': temperature,
        'high': high,
        'low': low,
      };
}
