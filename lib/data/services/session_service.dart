import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _key = 'omni_session_email';

  Future<String?> getSessionEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, email);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<bool> isLoggedIn() async => (await getSessionEmail()) != null;
}
