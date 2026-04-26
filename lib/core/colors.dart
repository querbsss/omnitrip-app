import 'package:flutter/material.dart';

class AppColors {
  // Drives whether color getters resolve to the light or dark palette.
  // Toggling this notifier re-renders MaterialApp through the listener in
  // [OmniTripApp], which causes every widget to re-read the getters below.
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDark => mode.value == ThemeMode.dark;

  // ── Light palette (cream + teal — the default OmniTrip aesthetic) ──
  static const Color _lBgCream = Color(0xFFF4ECD8);
  static const Color _lBgCreamLight = Color(0xFFFAF5E6);
  static const Color _lTealPrimary = Color(0xFF2D8A8A);
  static const Color _lTealDark = Color(0xFF1F6B6B);
  static const Color _lTealSoft = Color(0xFFB8DCDC);
  static const Color _lTealMuted = Color(0xFFD7EAEA);
  static const Color _lCardWhite = Color(0xFFFFFFFF);
  static const Color _lTextDark = Color(0xFF1F2937);
  static const Color _lTextMuted = Color(0xFF6B7280);
  static const Color _lTextSubtle = Color(0xFF9CA3AF);
  static const Color _lBorder = Color(0xFFE5E7EB);
  static const Color _lShadow = Color(0x14000000);

  // ── Dark palette (deep teal-navy, keeps teal as the accent identity) ──
  static const Color _dBgCream = Color(0xFF0F1722);
  static const Color _dBgCreamLight = Color(0xFF182231);
  static const Color _dTealPrimary = Color(0xFF55B8B8);
  static const Color _dTealDark = Color(0xFF7CD0D0);
  static const Color _dTealSoft = Color(0xFF1F3D3D);
  static const Color _dTealMuted = Color(0xFF263A3A);
  static const Color _dCardWhite = Color(0xFF1B2533);
  static const Color _dTextDark = Color(0xFFE8EDF4);
  static const Color _dTextMuted = Color(0xFFA0AAB8);
  static const Color _dTextSubtle = Color(0xFF6F7A8A);
  static const Color _dBorder = Color(0xFF2A3444);
  static const Color _dShadow = Color(0x33000000);

  static Color get bgCream => isDark ? _dBgCream : _lBgCream;
  static Color get bgCreamLight => isDark ? _dBgCreamLight : _lBgCreamLight;
  static Color get tealPrimary => isDark ? _dTealPrimary : _lTealPrimary;
  static Color get tealDark => isDark ? _dTealDark : _lTealDark;
  static Color get tealSoft => isDark ? _dTealSoft : _lTealSoft;
  static Color get tealMuted => isDark ? _dTealMuted : _lTealMuted;
  static Color get cardWhite => isDark ? _dCardWhite : _lCardWhite;
  static Color get textDark => isDark ? _dTextDark : _lTextDark;
  static Color get textMuted => isDark ? _dTextMuted : _lTextMuted;
  static Color get textSubtle => isDark ? _dTextSubtle : _lTextSubtle;
  static Color get border => isDark ? _dBorder : _lBorder;
  static Color get shadow => isDark ? _dShadow : _lShadow;

  // Accent colors — kept identical across modes so iconography reads the same.
  static const Color leisureColor = Color(0xFFFF9F1C);
  static const Color adventureColor = Color(0xFF2EC4B6);
  static const Color businessColor = Color(0xFF3A86FF);
  static const Color culturalColor = Color(0xFF8338EC);

  static const Color weatherSunny = Color(0xFFFFB703);
  static const Color weatherRainy = Color(0xFF219EBC);
  static const Color weatherStormy = Color(0xFF495867);
  static const Color weatherCloudy = Color(0xFF8DA9C4);
}
