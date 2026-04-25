import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum AuthStatus { success, emailExists, invalidCredentials }

class AuthResult {
  final AuthStatus status;
  final UserModel? user;
  final String? message;

  const AuthResult(this.status, {this.user, this.message});
}

class AuthService {
  static const String _usersKey = 'omni_users';

  Future<List<UserModel>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((j) => UserModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  String _encode(String password) =>
      base64Encode(utf8.encode(password.trim()));

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanedEmail = email.trim().toLowerCase();
    final users = await _readUsers();
    if (users.any((u) => u.email.toLowerCase() == cleanedEmail)) {
      return const AuthResult(
        AuthStatus.emailExists,
        message: 'An account with this email already exists.',
      );
    }
    final user = UserModel(
      name: name.trim(),
      email: cleanedEmail,
      passwordEncoded: _encode(password),
    );
    await _writeUsers([...users, user]);
    return AuthResult(AuthStatus.success, user: user);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final cleanedEmail = email.trim().toLowerCase();
    final users = await _readUsers();
    final encoded = _encode(password);
    UserModel? matched;
    for (final u in users) {
      if (u.email.toLowerCase() == cleanedEmail &&
          u.passwordEncoded == encoded) {
        matched = u;
        break;
      }
    }
    if (matched == null) {
      return const AuthResult(
        AuthStatus.invalidCredentials,
        message: 'Email or password is incorrect.',
      );
    }
    return AuthResult(AuthStatus.success, user: matched);
  }

  Future<UserModel?> findByEmail(String email) async {
    final users = await _readUsers();
    final cleaned = email.trim().toLowerCase();
    for (final u in users) {
      if (u.email.toLowerCase() == cleaned) return u;
    }
    return null;
  }
}
