class Origin {
  final String id;
  final String name;
  final String province;
  final String island;
  final String landMass;
  final double latitude;
  final double longitude;

  const Origin({
    required this.id,
    required this.name,
    required this.province,
    required this.island,
    required this.landMass,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => '$name, $province';
}
