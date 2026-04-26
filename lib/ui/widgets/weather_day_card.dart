import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../data/models/weather.dart';

class WeatherDayCard extends StatelessWidget {
  final WeatherDay day;
  final String label;

  const WeatherDayCard({super.key, required this.day, required this.label});

  Color _bg() {
    switch (day.condition) {
      case WeatherCondition.sunny:
        return const Color(0xFFFFF1D6);
      case WeatherCondition.partlyCloudy:
        return const Color(0xFFE5EEF5);
      case WeatherCondition.cloudy:
        return const Color(0xFFE3E8EF);
      case WeatherCondition.rainy:
        return const Color(0xFFD9EAF2);
      case WeatherCondition.stormy:
        return const Color(0xFFC9CFD8);
    }
  }

  Color _iconColor() {
    switch (day.condition) {
      case WeatherCondition.sunny:
        return AppColors.weatherSunny;
      case WeatherCondition.partlyCloudy:
      case WeatherCondition.cloudy:
        return AppColors.weatherCloudy;
      case WeatherCondition.rainy:
        return AppColors.weatherRainy;
      case WeatherCondition.stormy:
        return AppColors.weatherStormy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Icon(day.icon, color: _iconColor(), size: 24),
          const SizedBox(height: 6),
          Text(
            '${day.highC}°',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          Text(
            '${day.lowC}°',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
