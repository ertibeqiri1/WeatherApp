// TODO (Dev — Phase 2): Replace stub with full model + JSON parsing

class DailyForecastModel {
  final String day;
  final String condition;
  final double high;
  final double low;

  const DailyForecastModel({
    required this.day,
    required this.condition,
    required this.high,
    required this.low,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      day: json['day'] ?? '',
      condition: json['condition'] ?? '',
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'condition': condition,
        'high': high,
        'low': low,
      };
}
