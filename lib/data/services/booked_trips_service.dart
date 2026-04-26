import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/booked_trip.dart';

class BookedTripsService {
  static const String _keyPrefix = 'omni_booked_trips_';

  String _key(String email) => '$_keyPrefix${email.toLowerCase()}';

  Future<List<BookedTrip>> all(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(email));
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((j) => BookedTrip.fromJson(j as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.travelDate.compareTo(b.travelDate));
  }

  Future<void> _writeAll(String email, List<BookedTrip> trips) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(email),
      jsonEncode(trips.map((t) => t.toJson()).toList()),
    );
  }

  Future<BookedTrip> add({
    required String email,
    required String title,
    required String destinationId,
    required DateTime travelDate,
    required String purpose,
    required bool weatherAware,
    required bool trafficAware,
    String notes = '',
    String originLocation = '',
    int travelers = 1,
    String transportMode = 'commute',
  }) async {
    final now = DateTime.now();
    final trip = BookedTrip(
      id: '${now.microsecondsSinceEpoch}',
      userEmail: email,
      title: title.trim().isEmpty ? 'Trip' : title.trim(),
      destinationId: destinationId,
      travelDate: travelDate,
      purpose: purpose,
      weatherAware: weatherAware,
      trafficAware: trafficAware,
      notes: notes.trim(),
      createdAt: now,
      originLocation: originLocation.trim(),
      travelers: travelers < 1 ? 1 : travelers,
      transportMode: transportMode,
    );
    final list = await all(email);
    list.add(trip);
    await _writeAll(email, list);
    return trip;
  }

  Future<void> update(BookedTrip updated) async {
    final list = await all(updated.userEmail);
    final i = list.indexWhere((t) => t.id == updated.id);
    if (i == -1) return;
    list[i] = updated;
    await _writeAll(updated.userEmail, list);
  }

  Future<void> remove({required String email, required String id}) async {
    final list = await all(email);
    list.removeWhere((t) => t.id == id);
    await _writeAll(email, list);
  }
}
