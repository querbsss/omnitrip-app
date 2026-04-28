import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// LuxeTravel typography scale, built on Plus Jakarta Sans.
// Use these getters anywhere a heading/body/label is rendered so the
// type rhythm stays consistent across screens and themes.
class AppType {
  static TextStyle get headlineXl => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.56, // -0.02em
    color: AppColors.onSurface,
  );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    height: 30 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.22, // -0.01em
    color: AppColors.onSurface,
  );

  static TextStyle get titleLg => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.18,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get labelMd => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.24, // 0.02em
    color: AppColors.onSurface,
  );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5, // 0.05em
    color: AppColors.onSurfaceVariant,
  );
}
