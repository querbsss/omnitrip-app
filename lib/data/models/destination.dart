class Destination {
  final String id;
  final String name;
  final String region;
  final String province;
  final String shortDescription;
  final List<String> tags;
  final String emoji;
  final double latitude;
  final double longitude;
  final String climateZone;

  const Destination({
    required this.id,
    required this.name,
    required this.region,
    required this.province,
    required this.shortDescription,
    required this.tags,
    required this.emoji,
    required this.latitude,
    required this.longitude,
    required this.climateZone,
  });

  String get mapLink =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  String get geoUri =>
      'geo:$latitude,$longitude?q=${Uri.encodeComponent("$name, Philippines")}';
}
