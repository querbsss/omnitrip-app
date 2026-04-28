import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../data/models/weather.dart';

class WeatherDayCard extends StatelessWidget {
  final WeatherDay day;
  final String label;

  const WeatherDayCard({super.key, required this.day, required this.label});

  Color _bg() {
    switch (day.condition) {
      case WeatherCondition.sunny:
        return AppColors.weatherSunnyBg;
      case WeatherCondition.partlyCloudy:
        return AppColors.weatherPartlyBg;
      case WeatherCondition.cloudy:
        return AppColors.weatherCloudyBg;
      case WeatherCondition.rainy:
        return AppColors.weatherRainyBg;
      case WeatherCondition.stormy:
        return AppColors.weatherStormyBg;
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
    final bg = _bg();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bg.withValues(alpha: 0.95), bg.withValues(alpha: 0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppType.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Icon(day.icon, color: _iconColor(), size: 26),
          const SizedBox(height: 8),
          Text(
            '${day.highC}°',
            style: AppType.bodyMd.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            '${day.lowC}°',
            style: AppType.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
