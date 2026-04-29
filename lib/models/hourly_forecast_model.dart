// TODO (Dev — Phase 2): Replace stub with full model + JSON parsing

class HourlyForecastModel {
  final String time;
  final String condition;
  final double temperature;

  const HourlyForecastModel({
    required this.time,
    required this.condition,
    required this.temperature,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: json['time'] ?? '',
      condition: json['condition'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'condition': condition,
        'temperature': temperature,
      };
}
