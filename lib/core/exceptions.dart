/// Thrown when the API returns an error response
class WeatherApiException implements Exception {
  final String message;
  const WeatherApiException(this.message);

  @override
  String toString() => 'WeatherApiException: $message';
}

/// Thrown when the repository fails (network, parse, cache errors)
class WeatherRepositoryException implements Exception {
  final String message;
  const WeatherRepositoryException(this.message);

  @override
  String toString() => 'WeatherRepositoryException: $message';
}
