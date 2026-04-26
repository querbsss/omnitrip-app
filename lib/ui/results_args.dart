import '../data/models/travel_plan.dart';

class ResultsArgs {
  final TravelPlan plan;
  final String? savedTripId;

  const ResultsArgs(this.plan, {this.savedTripId});
}
