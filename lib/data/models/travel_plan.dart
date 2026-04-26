import 'activity.dart';
import 'cost_estimate.dart';
import 'destination.dart';
import 'route_info.dart';
import 'weather.dart';

class TravelPlan {
  final Destination destination;
  final DateTime travelDate;
  final String purpose;
  final bool weatherAware;
  final bool trafficAware;
  final WeatherForecast forecast;
  final RouteInfo routeInfo;
  final List<TravelActivity> activities;
  final List<String> packingTips;
  final List<String> insights;
  final String originLocation;
  final int travelers;
  final String transportMode;
  final CostEstimate costEstimate;

  const TravelPlan({
    required this.destination,
    required this.travelDate,
    required this.purpose,
    required this.weatherAware,
    required this.trafficAware,
    required this.forecast,
    required this.routeInfo,
    required this.activities,
    required this.packingTips,
    required this.insights,
    required this.originLocation,
    required this.travelers,
    required this.transportMode,
    required this.costEstimate,
  });
}
