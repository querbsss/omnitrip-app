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
  final String originLocation;
  final int travelers;
  final String transportMode;

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
    this.originLocation = '',
    this.travelers = 1,
    this.transportMode = 'commute',
  });

  BookedTrip copyWith({
    String? title,
    DateTime? travelDate,
    String? purpose,
    bool? weatherAware,
    bool? trafficAware,
    String? notes,
    String? originLocation,
    int? travelers,
    String? transportMode,
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
      originLocation: originLocation ?? this.originLocation,
      travelers: travelers ?? this.travelers,
      transportMode: transportMode ?? this.transportMode,
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
        originLocation: (json['originLocation'] as String?) ?? '',
        travelers: (json['travelers'] as int?) ?? 1,
        transportMode: (json['transportMode'] as String?) ?? 'commute',
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
        'originLocation': originLocation,
        'travelers': travelers,
        'transportMode': transportMode,
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

  static String transportLabel(String mode) {
    switch (mode) {
      case 'commute':
        return 'Public Commute';
      case 'private':
        return 'Private Vehicle';
      default:
        return mode;
    }
  }
}
