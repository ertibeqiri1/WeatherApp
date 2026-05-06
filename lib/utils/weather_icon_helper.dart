import 'package:flutter/material.dart';

/// Maps a weather condition string to a display emoji.
/// Used across all forecast widgets to keep icons consistent.
class WeatherIconHelper {
  WeatherIconHelper._();

  static List<Color> conditionToGradient(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('sunny') || c.contains('clear')) {
      return const [Color(0xFFFFB347), Color(0xFFFF7043), Color(0xFFE64A19)];
    }
    if (c.contains('partly cloudy')) {
      return const [Color(0xFF5BA3D9), Color(0xFF3A7FBF), Color(0xFF1E5799)];
    }
    if (c.contains('cloudy') || c.contains('overcast')) {
      return const [Color(0xFF78909C), Color(0xFF546E7A), Color(0xFF37474F)];
    }
    if (c.contains('rain') || c.contains('drizzle') || c.contains('shower')) {
      return const [Color(0xFF4A6FA5), Color(0xFF2C4A7C), Color(0xFF1A2F52)];
    }
    if (c.contains('thunder') || c.contains('storm')) {
      return const [Color(0xFF37474F), Color(0xFF263238), Color(0xFF1A1A2E)];
    }
    if (c.contains('snow') || c.contains('blizzard')) {
      return const [Color(0xFFB0BEC5), Color(0xFF90A4AE), Color(0xFF78909C)];
    }
    if (c.contains('fog') || c.contains('mist') || c.contains('haze')) {
      return const [Color(0xFF8D9DB6), Color(0xFF667B99), Color(0xFF4A5E78)];
    }
    if (c.contains('sunset') || c.contains('sunrise')) {
      return const [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFC371)];
    }
    // default — same as app default blue
    return const [Color(0xFF5BA3D9), Color(0xFF3A7FBF), Color(0xFF1E5799)];
  }

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
