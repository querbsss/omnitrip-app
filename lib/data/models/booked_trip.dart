class BookedTrip {
  final String id;
  final String userEmail;
  final String title;
  final String destinationId;
  final DateTime travelDate;
  final String purpose;
  final bool weatherAware;
  final bool trafficAware;
  final String notes;
  final DateTime createdAt;

  const BookedTrip({
    required this.id,
    required this.userEmail,
    required this.title,
    required this.destinationId,
    required this.travelDate,
    required this.purpose,
    required this.weatherAware,
    required this.trafficAware,
    required this.notes,
    required this.createdAt,
  });

  BookedTrip copyWith({
    String? title,
    DateTime? travelDate,
    String? purpose,
    bool? weatherAware,
    bool? trafficAware,
    String? notes,
  }) {
    return BookedTrip(
      id: id,
      userEmail: userEmail,
      title: title ?? this.title,
      destinationId: destinationId,
      travelDate: travelDate ?? this.travelDate,
      purpose: purpose ?? this.purpose,
      weatherAware: weatherAware ?? this.weatherAware,
      trafficAware: trafficAware ?? this.trafficAware,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  factory BookedTrip.fromJson(Map<String, dynamic> json) => BookedTrip(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        title: json['title'] as String,
        destinationId: json['destinationId'] as String,
        travelDate: DateTime.parse(json['travelDate'] as String),
        purpose: json['purpose'] as String,
        weatherAware: json['weatherAware'] as bool,
        trafficAware: json['trafficAware'] as bool,
        notes: (json['notes'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'title': title,
        'destinationId': destinationId,
        'travelDate': travelDate.toIso8601String(),
        'purpose': purpose,
        'weatherAware': weatherAware,
        'trafficAware': trafficAware,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  static String purposeLabel(String purpose) {
    switch (purpose) {
      case 'vacation':
        return 'Vacation';
      case 'date_idea':
        return 'Date Idea';
      case 'school_business':
        return 'School / Business';
      default:
        return purpose;
    }
  }
}
