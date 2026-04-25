class TravelActivity {
  final String id;
  final String destinationId;
  final String title;
  final String description;
  final List<String> purposeTags;
  final String emoji;
  final String duration;

  const TravelActivity({
    required this.id,
    required this.destinationId,
    required this.title,
    required this.description,
    required this.purposeTags,
    required this.emoji,
    required this.duration,
  });
}
