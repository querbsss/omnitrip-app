class RouteInfo {
  final String fromHub;
  final String toDestination;
  final List<String> steps;
  final String estimatedTravel;
  final String estimatedTrafficMin;
  final String transportMode;
  final String trafficAdvisory;

  const RouteInfo({
    required this.fromHub,
    required this.toDestination,
    required this.steps,
    required this.estimatedTravel,
    required this.estimatedTrafficMin,
    required this.transportMode,
    required this.trafficAdvisory,
  });
}
