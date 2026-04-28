import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// Builds a single ThemeData reflecting the current value of AppColors.mode.
// Rebuild this whenever the mode notifier changes.
ThemeData buildAppTheme() {
  final brightness = AppColors.isDark ? Brightness.dark : Brightness.light;
  final base = brightness == Brightness.dark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);

  final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
    bodyColor: AppColors.onSurface,
    displayColor: AppColors.onSurface,
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bgSurface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF28C55),
      brightness: brightness,
    ).copyWith(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.onBrand,
      primaryContainer: AppColors.brandPrimary,
      onPrimaryContainer: AppColors.onBrand,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      surface: AppColors.bgSurface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceCard,
      surfaceContainerLow: AppColors.surfaceLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceHigh,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgSurface.withValues(alpha: 0.85),
      foregroundColor: AppColors.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceCard,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: AppColors.onBrand,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.16,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandDeep,
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLow,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: AppColors.brandPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.outlineVariant,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLow,
      selectedColor: AppColors.secondaryContainer,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.brandPrimary
            : AppColors.outlineVariant,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.outlineVariant.withValues(alpha: 0.5),
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.brandPrimary,
      foregroundColor: AppColors.onBrand,
      elevation: 0,
      highlightElevation: 0,
      shape: const StadiumBorder(),
    ),
  );
}
