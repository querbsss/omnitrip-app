import 'dart:math' as math;

import '../datasets/activities.dart';
import '../datasets/origins.dart';
import '../datasets/routes.dart';
import '../models/activity.dart';
import '../models/cost_estimate.dart';
import '../models/destination.dart';
import '../models/origin.dart';
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
    String originLocation = '',
    int travelers = 1,
    String transportMode = 'commute',
  }) {
    final origin = Origins.byName(originLocation);
    final forecast = _buildForecast(destination, travelDate);
    final route = _buildRoute(destination, trafficAware);
    final activities = _filterActivities(destination, purpose);
    final packing = _packingTips(forecast, destination, purpose);
    final insights = _insights(destination, forecast, purpose);
    final cost = _buildCostEstimate(
      destination: destination,
      origin: origin,
      purpose: purpose,
      travelers: travelers,
      transportMode: transportMode,
    );

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
      originLocation: originLocation,
      travelers: travelers < 1 ? 1 : travelers,
      transportMode: transportMode,
      costEstimate: cost,
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

  // Maps destination ids to land mass ids so we can detect whether origin
  // and destination are on the same drivable island.
  static String landMassForDestination(Destination dest) {
    switch (dest.id) {
      // Luzon mainland
      case 'manila':
      case 'baguio':
      case 'tagaytay':
      case 'batangas':
      case 'vigan':
      case 'laoag':
      case 'sagada':
      case 'angeles':
      case 'subic':
      case 'baler':
      case 'lucena':
      case 'naga':
      case 'legazpi':
      case 'pagudpud':
        return 'luzon';
      case 'puerto_galera':
        return 'mindoro';
      case 'coron':
      case 'el_nido':
      case 'puerto_princesa':
        return 'palawan';
      // Visayas islands
      case 'cebu_city':
      case 'malapascua':
      case 'moalboal':
      case 'bantayan':
        return 'cebu';
      case 'boracay':
        return 'boracay';
      case 'bohol':
        return 'bohol';
      case 'dumaguete':
      case 'bacolod':
        return 'negros';
      case 'iloilo':
      case 'kalibo':
        return 'panay';
      case 'guimaras':
        return 'guimaras';
      case 'tacloban':
      case 'borongan':
        return 'leyte_samar';
      case 'camiguin':
        return 'camiguin';
      case 'siquijor':
        return 'siquijor';
      // Mindanao mainland
      case 'davao':
      case 'cdo':
      case 'gensan':
      case 'zamboanga':
      case 'bukidnon':
      case 'lake_sebu':
      case 'iligan':
      case 'cotabato':
      case 'bislig':
      case 'pagadian':
      case 'butuan':
        return 'mindanao';
      case 'siargao':
        return 'siargao';
      default:
        return 'luzon';
    }
  }

  // Returns true when a private vehicle is realistic for the trip — origin
  // and destination must sit on the same drivable land mass. When no origin
  // is provided we fall back to a Manila-based heuristic.
  static bool privateVehicleApplicable(Destination dest, [Origin? origin]) {
    final destLand = landMassForDestination(dest);
    if (origin != null) {
      return origin.landMass == destLand;
    }
    // No origin chosen yet — assume Metro Manila (Luzon).
    return destLand == 'luzon';
  }

  CostEstimate _buildCostEstimate({
    required Destination destination,
    required Origin? origin,
    required String purpose,
    required int travelers,
    required String transportMode,
  }) {
    final t = travelers < 1 ? 1 : travelers;

    // Use the chosen origin when available, otherwise fall back to Manila so
    // legacy plans without an origin still produce sane numbers.
    final effectiveOrigin = origin ?? Origins.byId('manila')!;
    final destLand = landMassForDestination(destination);
    final sameLandMass = effectiveOrigin.landMass == destLand;

    final straightKm = _haversineKm(
      effectiveOrigin.latitude,
      effectiveOrigin.longitude,
      destination.latitude,
      destination.longitude,
    );
    // Roads in PH meander; bump straight-line by ~30% to approximate road km.
    final roadKm = straightKm * 1.3;

    double transportPerPerson;
    String transportLabel;
    String effectiveMode;
    if (!sameLandMass) {
      // Cross-island — driving isn't possible, must fly/ferry.
      effectiveMode = 'commute';
      transportPerPerson = _flyFerryFare(straightKm);
      transportLabel =
          'Round-trip airfare/ferry (per person, ~${straightKm.round()} km)';
    } else if (transportMode == 'private') {
      effectiveMode = 'private';
      final total = _privateDriveTotal(roadKm);
      transportPerPerson = total / t;
      transportLabel =
          'Fuel + tolls (~${roadKm.round()} km RT, split among $t)';
    } else {
      effectiveMode = 'commute';
      transportPerPerson = _commuteFare(roadKm);
      transportLabel =
          'Bus / van / jeepney (per person, ~${roadKm.round()} km)';
    }

    final lodgingPerPerson = _lodgingFor(destination, purpose);
    final foodPerPerson = _foodFor(destination, purpose);
    final activitiesPerPerson = _activitiesCostFor(destination, purpose);
    const miscPerPerson = 400.0;

    return CostEstimate(
      travelers: t,
      transportMode: effectiveMode,
      items: [
        CostBreakdown(
          label: transportLabel,
          amount: transportPerPerson * t,
        ),
        CostBreakdown(
          label: 'Lodging (1 night, per person)',
          amount: lodgingPerPerson * t,
        ),
        CostBreakdown(
          label: 'Food & drinks (per person)',
          amount: foodPerPerson * t,
        ),
        CostBreakdown(
          label: 'Activities & entrance fees',
          amount: activitiesPerPerson * t,
        ),
        CostBreakdown(
          label: 'Misc / buffer',
          amount: miscPerPerson * t,
        ),
      ],
    );
  }

  // Great-circle distance (km) between two coordinates.
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthKm = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthKm * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180.0);

  // Round-trip per-person bus / van fare in PHP, scaled by road km.
  double _commuteFare(double roadKm) {
    final fare = 100 + roadKm * 6.5;
    return fare.clamp(150, 6500);
  }

  // Total round-trip fuel + tolls (PHP) for a private drive — split among
  // travelers at the call site.
  double _privateDriveTotal(double roadKm) {
    final fuel = roadKm * 2 * 6.0; // round trip × ~6 PHP/km fuel cost
    double tolls = 0;
    if (roadKm > 200) {
      tolls = 600;
    } else if (roadKm > 80) {
      tolls = 300;
    }
    return (fuel + tolls).clamp(400, 12000);
  }

  // Round-trip per-person airfare or fast ferry in PHP, scaled by straight-
  // line km between origin and destination.
  double _flyFerryFare(double straightKm) {
    final fare = 2500 + straightKm * 6.5;
    return fare.clamp(3000, 15000);
  }

  double _lodgingFor(Destination dest, String purpose) {
    // Per person per night in PHP.
    final premium = dest.tags.contains('beach') ||
        dest.tags.contains('island') ||
        dest.tags.contains('diving');
    if (purpose == 'date_idea') {
      return premium ? 2800 : 2000;
    }
    if (purpose == 'school_business') {
      return 1800;
    }
    return premium ? 2200 : 1500;
  }

  double _foodFor(Destination dest, String purpose) {
    if (purpose == 'date_idea') return 1500;
    if (purpose == 'school_business') return 900;
    return 1100;
  }

  double _activitiesCostFor(Destination dest, String purpose) {
    if (dest.tags.contains('diving')) return 2500;
    if (dest.tags.contains('island') || dest.tags.contains('beach')) {
      return 1500;
    }
    if (dest.tags.contains('adventure') || dest.tags.contains('mountain')) {
      return 1200;
    }
    if (purpose == 'date_idea') return 1300;
    if (purpose == 'school_business') return 500;
    return 900;
  }
}
