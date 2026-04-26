import 'package:flutter/material.dart';

import 'app.dart';
import 'core/colors.dart';
import 'data/services/auth_service.dart';
import 'data/services/session_service.dart';
import 'data/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsService();
  AppColors.mode.value = await settings.getThemeMode();

  final loggedIn = await SessionService().isLoggedIn();
  final hasAccount = loggedIn ? true : await AuthService().hasAnyUser();

  final String startRoute;
  if (loggedIn) {
    startRoute = '/planner';
  } else if (hasAccount) {
    startRoute = '/login';
  } else {
    startRoute = '/';
  }

  runApp(OmniTripApp(startRoute: startRoute));
}
