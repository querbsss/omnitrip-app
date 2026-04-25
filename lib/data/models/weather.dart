import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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
        return HugeIcons.strokeRoundedSun03;
      case WeatherCondition.partlyCloudy:
        return HugeIcons.strokeRoundedCloud;
      case WeatherCondition.cloudy:
        return HugeIcons.strokeRoundedCloud;
      case WeatherCondition.rainy:
        return HugeIcons.strokeRoundedUmbrella;
      case WeatherCondition.stormy:
        return HugeIcons.strokeRoundedCloudFastWind;
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
