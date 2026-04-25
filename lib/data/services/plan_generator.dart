import '../datasets/activities.dart';
import '../datasets/routes.dart';
import '../models/activity.dart';
import '../models/destination.dart';
import '../models/route_info.dart';
import '../models/travel_plan.dart';
import '../models/weather.dart';

class PlanGenerator {
  TravelPlan generate({
    required Destination destination,
    required DateTime travelDate,
    required String purpose,
    required bool weatherAware,
    required bool trafficAware,
  }) {
    final forecast = _buildForecast(destination, travelDate);
    final route = _buildRoute(destination, trafficAware);
    final activities = _filterActivities(destination, purpose);
    final packing = _packingTips(forecast, destination, purpose);
    final insights = _insights(destination, forecast, purpose);

    return TravelPlan(
      destination: destination,
      travelDate: travelDate,
      purpose: purpose,
      weatherAware: weatherAware,
      trafficAware: trafficAware,
      forecast: forecast,
      routeInfo: route,
      activities: activities,
      packingTips: packing,
      insights: insights,
    );
  }

  WeatherForecast _buildForecast(Destination dest, DateTime date) {
    final season = _seasonFor(date.month, dest.climateZone);
    final baseHigh = _baseHigh(dest, date.month);
    final baseLow = _baseLow(dest, date.month);
    final baseCondition = _baseCondition(dest.climateZone, date.month);

    final seed = (dest.id.hashCode ^ date.day ^ date.month).abs();
    final days = List<WeatherDay>.generate(5, (i) {
      final variance = ((seed >> i) & 0x3) - 1; // -1, 0, 1, or 2
      final cond = _shiftCondition(baseCondition, (seed >> (i + 1)) & 0x3);
      return WeatherDay(
        dayIndex: i,
        condition: cond,
        highC: baseHigh + variance,
        lowC: baseLow + (variance ~/ 2),
      );
    });

    return WeatherForecast(
      days: days,
      season: season,
      advisory: _advisoryFor(season, dest),
    );
  }

  String _seasonFor(int month, String zone) {
    if (month >= 12 || month <= 2) {
      if (zone == 'type2') return 'Wet Season';
      return 'Cool & Dry Season';
    }
    if (month >= 3 && month <= 5) return 'Hot & Dry Season';
    if (month >= 6 && month <= 9) {
      if (zone == 'type1') return 'Wet / Habagat Season';
      if (zone == 'type4') return 'Light Rainy Season';
      return 'Rainy Season';
    }
    return 'Transition Season';
  }

  int _baseHigh(Destination dest, int month) {
    if (dest.id == 'baguio' || dest.id == 'sagada') {
      return month >= 3 && month <= 5 ? 24 : 21;
    }
    if (dest.id == 'bukidnon') {
      return month >= 3 && month <= 5 ? 28 : 26;
    }
    if (dest.region == 'Mindanao') {
      return month >= 3 && month <= 5 ? 33 : 31;
    }
    if (dest.region == 'Visayas') {
      return month >= 3 && month <= 5 ? 33 : 31;
    }
    if (month >= 3 && month <= 5) return 34;
    if (month >= 6 && month <= 9) return 30;
    if (month >= 12 || month <= 2) return 28;
    return 31;
  }

  int _baseLow(Destination dest, int month) => _baseHigh(dest, month) - 6;

  WeatherCondition _baseCondition(String zone, int month) {
    if (month >= 6 && month <= 9) {
      if (zone == 'type1' || zone == 'type3') return WeatherCondition.rainy;
      return WeatherCondition.partlyCloudy;
    }
    if (month >= 12 || month <= 2) {
      if (zone == 'type2') return WeatherCondition.rainy;
      return WeatherCondition.sunny;
    }
    if (month >= 3 && month <= 5) return WeatherCondition.sunny;
    return WeatherCondition.partlyCloudy;
  }

  WeatherCondition _shiftCondition(WeatherCondition base, int variance) {
    final values = WeatherCondition.values;
    final idx = base.index;
    final shifted = (idx + variance - 1).clamp(0, values.length - 1);
    return values[shifted];
  }

  String _advisoryFor(String season, Destination dest) {
    if (season.contains('Rainy') || season.contains('Wet')) {
      return 'Bring a compact umbrella and water-resistant bag — quick afternoon showers expected.';
    }
    if (season.contains('Hot')) {
      return 'High UV index. Hydrate well, wear sunscreen SPF 50+, and carry a hat.';
    }
    if (dest.id == 'baguio' || dest.id == 'sagada') {
      return 'Cool nights down to 14°C. Pack a light jacket and warm layers.';
    }
    return 'Mild and pleasant — great window for outdoor activities.';
  }

  RouteInfo _buildRoute(Destination dest, bool trafficAware) {
    final base = Routes.forDestination(dest.id);
    if (!trafficAware) {
      return RouteInfo(
        fromHub: base.fromHub,
        toDestination: base.toDestination,
        steps: base.steps,
        estimatedTravel: base.estimatedTravel,
        estimatedTrafficMin: base.estimatedTrafficMin,
        transportMode: base.transportMode,
        trafficAdvisory: 'Traffic awareness disabled — enable on the planner for real-time tips.',
      );
    }
    return base;
  }

  List<TravelActivity> _filterActivities(Destination dest, String purpose) {
    final list = Activities.forDestination(dest.id, purpose: purpose);
    if (list.length <= 5) return list;
    return list.take(5).toList();
  }

  List<String> _packingTips(WeatherForecast forecast, Destination dest, String purpose) {
    final tips = <String>{};
    final hasRain = forecast.days.any((d) =>
        d.condition == WeatherCondition.rainy ||
        d.condition == WeatherCondition.stormy);
    final hasSun = forecast.days.any((d) =>
        d.condition == WeatherCondition.sunny);

    if (hasRain) {
      tips.add('Compact umbrella');
      tips.add('Water-resistant jacket');
      tips.add('Quick-dry shoes');
    }
    if (hasSun) {
      tips.add('Sunscreen (SPF 50+)');
      tips.add('Refillable water bottle');
      tips.add('Hat or cap');
    }
    if (dest.id == 'baguio' || dest.id == 'sagada' || dest.id == 'bukidnon') {
      tips.add('Light jacket / sweater');
    }
    if (dest.tags.contains('beach') || dest.tags.contains('island')) {
      tips.add('Swimsuit & rash guard');
      tips.add('Beach slippers');
    }
    if (dest.tags.contains('diving')) {
      tips.add('Reef-safe sunscreen');
    }
    if (dest.tags.contains('mountain') || dest.tags.contains('adventure')) {
      tips.add('Trail shoes');
    }
    if (purpose == 'school_business') {
      tips.add('Notebook / tablet');
      tips.add('Smart-casual outfit');
    }
    if (purpose == 'date_idea') {
      tips.add('A nice outfit for sunset photos');
    }
    return tips.toList();
  }

  List<String> _insights(Destination dest, WeatherForecast forecast, String purpose) {
    return [
      '${dest.name} is in ${dest.region} — ${dest.shortDescription}',
      'You\'re visiting during the ${forecast.season.toLowerCase()}.',
      'Top local tags: ${dest.tags.take(3).join(", ")}',
      if (purpose == 'date_idea')
        'Pro tip: book sunset spots at least 2 hours ahead — they fill fast.',
      if (purpose == 'school_business')
        'Carry a power bank and offline maps in case of weak signal.',
      if (purpose == 'vacation')
        'Mid-week trips to ${dest.name} usually mean lighter crowds and lower rates.',
    ];
  }
}
