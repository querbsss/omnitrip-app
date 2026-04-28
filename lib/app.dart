import 'package:flutter/material.dart';

import 'core/colors.dart';
import 'core/theme.dart';
import 'ui/about_screen.dart';
import 'ui/booked_trips_screen.dart';
import 'ui/help_screen.dart';
import 'ui/home_screen.dart';
import 'ui/login_screen.dart';
import 'ui/planner_screen.dart';
import 'ui/profile_screen.dart';
import 'ui/register_screen.dart';
import 'ui/results_screen.dart';
import 'ui/settings_screen.dart';
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
            '/home': (_) => const HomeScreen(),
            '/planner': (_) => const PlannerScreen(),
            '/results': (_) => const ResultsScreen(),
            '/booked': (_) => const BookedTripsScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/help': (_) => const HelpScreen(),
            '/about': (_) => const AboutScreen(),
          },
          builder: (context, child) {
            // Constrain UI to a phone-like frame on wide (web/desktop) viewports.
            final size = MediaQuery.of(context).size;
            if (size.width <= 520) return child!;
            return ColoredBox(
              color: AppColors.isDark
                  ? const Color(0xFF0B0D0E)
                  : const Color(0xFFE6E2DC),
              child: Center(
                child: Container(
                  width: 420,
                  constraints: const BoxConstraints(maxHeight: 900),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.isDark
                            ? const Color(0x99000000)
                            : const Color(0x33994715),
                        blurRadius: 60,
                        spreadRadius: -8,
                        offset: const Offset(0, 24),
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
