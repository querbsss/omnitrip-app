import 'package:flutter/material.dart';

import 'app.dart';
import 'data/services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await SessionService().isLoggedIn();
  runApp(OmniTripApp(startLoggedIn: loggedIn));
}
