/// Maps a weather condition string to a display emoji.
/// Used across all forecast widgets to keep icons consistent.
class WeatherIconHelper {
  WeatherIconHelper._();

  static String getEmoji(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('sunny') || c.contains('clear')) return '☀️';
    if (c.contains('partly cloudy')) return '⛅';
    if (c.contains('cloudy') || c.contains('overcast')) return '☁️';
    if (c.contains('light rain') || c.contains('drizzle')) return '🌦️';
    if (c.contains('rain') || c.contains('shower')) return '🌧️';
    if (c.contains('thunder') || c.contains('storm')) return '⛈️';
    if (c.contains('snow') || c.contains('blizzard')) return '❄️';
    if (c.contains('fog') || c.contains('mist') || c.contains('haze')) return '🌫️';
    if (c.contains('wind')) return '💨';
    if (c.contains('sunset')) return '🌅';
    if (c.contains('sunrise')) return '🌄';
    return '🌡️';
  }

  /// Returns a short label suitable for small forecast cards.
  static String shortLabel(String condition) {
    if (condition.length <= 12) return condition;
    final words = condition.split(' ');
    return words.length > 1 ? words.take(2).join('\n') : condition;
  }
}
