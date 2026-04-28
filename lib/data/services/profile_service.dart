import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-user profile preferences (currently just the chosen avatar emoji).
/// Stored as a shared_preferences string keyed by lowercased email so
/// switching accounts on the same device shows each user's pick.
class ProfileService {
  static const String _avatarPrefix = 'omni_avatar_';

  /// Default avatars users can pick from. Keep these emoji-only so they
  /// render the same across web, iOS, Android, and the demo's wide-screen
  /// phone frame without needing icon assets.
  static const List<String> avatarChoices = [
    '🧳', '🌴', '🏖️', '⛰️',
    '🌅', '✈️', '🚗', '🎒',
    '📷', '🗺️', '🏝️', '🏔️',
  ];

  /// Bumped whenever any profile field changes so cached widgets (the
  /// drawer header, the home greeting, the AppBar avatar shortcut) can
  /// re-fetch from disk without each screen wiring its own callback.
  /// The integer value is meaningless — listeners just react to changes.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  String _key(String email) => '$_avatarPrefix${email.toLowerCase()}';

  Future<String?> getAvatar(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(email));
  }

  Future<void> setAvatar(String email, String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(email), emoji);
    changes.value++;
  }
}
