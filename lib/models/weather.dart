class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });
}
