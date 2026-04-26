class CostBreakdown {
  final String label;
  final double amount;

  const CostBreakdown({required this.label, required this.amount});
}

class CostEstimate {
  final List<CostBreakdown> items;
  final int travelers;
  final String transportMode;
  final String currency;

  const CostEstimate({
    required this.items,
    required this.travelers,
    required this.transportMode,
    this.currency = 'PHP',
  });

  double get total =>
      items.fold(0.0, (sum, item) => sum + item.amount);

  double get perPerson => travelers <= 0 ? total : total / travelers;
}
