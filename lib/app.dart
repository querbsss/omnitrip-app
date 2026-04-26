import 'package:flutter/material.dart';

import 'core/colors.dart';
import 'core/theme.dart';
import 'ui/booked_trips_screen.dart';
import 'ui/login_screen.dart';
import 'ui/planner_screen.dart';
import 'ui/register_screen.dart';
import 'ui/results_screen.dart';
import 'ui/welcome_screen.dart';

class OmniTripApp extends StatelessWidget {
  final String startRoute;
  const OmniTripApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppColors.mode,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'OmniTrip',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          initialRoute: startRoute,
          routes: {
            '/': (_) => const WelcomeScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/planner': (_) => const PlannerScreen(),
            '/results': (_) => const ResultsScreen(),
            '/booked': (_) => const BookedTripsScreen(),
          },
          builder: (context, child) {
            // Constrain UI to a phone-like frame on wide (web/desktop) viewports.
            final size = MediaQuery.of(context).size;
            if (size.width <= 520) return child!;
            return ColoredBox(
              color: AppColors.isDark
                  ? const Color(0xFF05080D)
                  : const Color(0xFF1F2937),
              child: Center(
                child: Container(
                  width: 420,
                  constraints: const BoxConstraints(maxHeight: 900),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
