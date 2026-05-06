import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/daily_forecast_model.dart';
import '../../utils/weather_icon_helper.dart';

class DailyItem extends StatelessWidget {
  final DailyForecastModel item;
  final bool showDivider;
  final double Function(double) convertTemp;
  final String unitLabel;

  const DailyItem({
    super.key,
    required this.item,
    required this.convertTemp,
    required this.unitLabel,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            children: [
              // Day label
              SizedBox(
                width: 56,
                child: Text(
                  item.day,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Weather icon
              Text(
                WeatherIconHelper.getEmoji(item.condition),
                style: const TextStyle(fontSize: 28),
              ),
              const Spacer(),
              // Low / High
              Text(
                'L:${convertTemp(item.low).toInt()}$unitLabel / H:${convertTemp(item.high).toInt()}$unitLabel',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(color: AppColors.divider, height: 1, thickness: 1),
      ],
    );
  }
}
