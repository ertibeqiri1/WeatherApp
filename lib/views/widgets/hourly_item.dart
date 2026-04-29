import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/hourly_forecast_model.dart';
import '../../utils/weather_icon_helper.dart';

class HourlyItem extends StatelessWidget {
  final HourlyForecastModel item;
  final bool isNow;

  const HourlyItem({super.key, required this.item, this.isNow = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isNow ? 'Now' : item.time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isNow ? FontWeight.w700 : FontWeight.w400,
            color: isNow ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          WeatherIconHelper.getEmoji(item.condition),
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 6),
        Text(
          WeatherIconHelper.shortLabel(item.condition),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${item.temperature.toInt()}°C',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
