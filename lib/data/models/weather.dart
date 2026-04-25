import 'package:flutter/material.dart';

enum WeatherCondition { sunny, partlyCloudy, cloudy, rainy, stormy }

class WeatherDay {
  final int dayIndex;
  final WeatherCondition condition;
  final int highC;
  final int lowC;

  const WeatherDay({
    required this.dayIndex,
    required this.condition,
    required this.highC,
    required this.lowC,
  });

  String get label => 'Day ${dayIndex + 1}';

  IconData get icon {
    switch (condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.partlyCloudy:
        return Icons.wb_cloudy_outlined;
      case WeatherCondition.cloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.rainy:
        return Icons.umbrella_rounded;
      case WeatherCondition.stormy:
        return Icons.thunderstorm_rounded;
    }
  }

  String get conditionLabel {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'Sunny';
      case WeatherCondition.partlyCloudy:
        return 'Partly Cloudy';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.stormy:
        return 'Stormy';
    }
  }
}

class WeatherForecast {
  final List<WeatherDay> days;
  final String season;
  final String advisory;

  const WeatherForecast({
    required this.days,
    required this.season,
    required this.advisory,
  });
}
