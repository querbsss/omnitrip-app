import 'package:flutter/material.dart';

class AppColors {
  // Theme is locked to light. The notifier is retained because [OmniTripApp]
  // wires a ValueListenableBuilder against it; nothing toggles it anymore.
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  // Always false — dark mode was removed. Dark palette constants below are
  // kept for reference but the getters never resolve to them.
  static bool get isDark => false;

  // ── LuxeTravel palette ──
  // Light: cool off-white surface with burnt-sienna + warm-orange brand accents.
  // Dark : deep neutrals with the same warm orange family kept as the accent.

  // Surfaces
  static const Color _lSurface = Color(0xFFF7FAFB);
  static const Color _lSurfaceCard = Color(0xFFFFFFFF);
  static const Color _lSurfaceLow = Color(0xFFF1F4F5);
  static const Color _lSurfaceContainer = Color(0xFFEBEEEF);
  static const Color _lSurfaceHigh = Color(0xFFE6E9EA);
  static const Color _dSurface = Color(0xFF181C1D);
  static const Color _dSurfaceCard = Color(0xFF1E2122);
  static const Color _dSurfaceLow = Color(0xFF23272A);
  static const Color _dSurfaceContainer = Color(0xFF2A2E30);
  static const Color _dSurfaceHigh = Color(0xFF32363A);

  // Brand (warm orange family)
  static const Color _lBrandPrimary = Color(0xFFF28C55); // primary-container
  static const Color _lBrandDeep = Color(0xFF994715); // primary
  static const Color _lBrandSoft = Color(0xFFFFDBCB); // primary-fixed
  static const Color _lBrandFixedDim = Color(0xFFFFB691); // primary-fixed-dim
  static const Color _lOnBrand = Color(0xFFFFFFFF); // on-primary-container (CTA text)
  static const Color _lOnBrandDeep = Color(0xFF682900); // on-primary-container

  static const Color _dBrandPrimary = Color(0xFFFFB691); // inverse-primary
  static const Color _dBrandDeep = Color(0xFFFFDBCB);
  static const Color _dBrandSoft = Color(0xFF793100);
  static const Color _dBrandFixedDim = Color(0xFFB85F2E);
  static const Color _dOnBrand = Color(0xFF341100);
  static const Color _dOnBrandDeep = Color(0xFFFFDBCB);

  // Secondary (muted olive — used for "Best Value" badges, mood chips)
  static const Color _lSecondary = Color(0xFF586240);
  static const Color _lSecondaryContainer = Color(0xFFD9E5B9);
  static const Color _lOnSecondaryContainer = Color(0xFF5D6744);
  static const Color _dSecondary = Color(0xFFC0CBA1);
  static const Color _dSecondaryContainer = Color(0xFF414A2A);
  static const Color _dOnSecondaryContainer = Color(0xFFDCE7BC);

  // Text + outlines
  static const Color _lOnSurface = Color(0xFF181C1D);
  static const Color _lOnSurfaceVariant = Color(0xFF55433A);
  static const Color _lOutline = Color(0xFF887369);
  static const Color _lOutlineVariant = Color(0xFFDBC1B6);

  static const Color _dOnSurface = Color(0xFFEEF1F2);
  static const Color _dOnSurfaceVariant = Color(0xFFB8A89E);
  static const Color _dOutline = Color(0xFF8E7A70);
  static const Color _dOutlineVariant = Color(0xFF463A33);

  // Shadow
  static const Color _lShadow = Color(0x14000000);
  static const Color _dShadow = Color(0x33000000);

  // ── New descriptive getters (preferred — use these in new code) ──
  static Color get bgSurface => isDark ? _dSurface : _lSurface;
  static Color get surfaceCard => isDark ? _dSurfaceCard : _lSurfaceCard;
  static Color get surfaceLow => isDark ? _dSurfaceLow : _lSurfaceLow;
  static Color get surfaceContainer =>
      isDark ? _dSurfaceContainer : _lSurfaceContainer;
  static Color get surfaceHigh => isDark ? _dSurfaceHigh : _lSurfaceHigh;

  static Color get brandPrimary => isDark ? _dBrandPrimary : _lBrandPrimary;
  static Color get brandDeep => isDark ? _dBrandDeep : _lBrandDeep;
  static Color get brandSoft => isDark ? _dBrandSoft : _lBrandSoft;
  static Color get brandFixedDim =>
      isDark ? _dBrandFixedDim : _lBrandFixedDim;
  static Color get onBrand => isDark ? _dOnBrand : _lOnBrand;
  static Color get onBrandDeep => isDark ? _dOnBrandDeep : _lOnBrandDeep;

  static Color get secondary => isDark ? _dSecondary : _lSecondary;
  static Color get secondaryContainer =>
      isDark ? _dSecondaryContainer : _lSecondaryContainer;
  static Color get onSecondaryContainer =>
      isDark ? _dOnSecondaryContainer : _lOnSecondaryContainer;

  static Color get onSurface => isDark ? _dOnSurface : _lOnSurface;
  static Color get onSurfaceVariant =>
      isDark ? _dOnSurfaceVariant : _lOnSurfaceVariant;
  static Color get outline => isDark ? _dOutline : _lOutline;
  static Color get outlineVariant =>
      isDark ? _dOutlineVariant : _lOutlineVariant;

  // ── Legacy aliases (existing code still references these names) ──
  // Repointed to the new tokens so the visual swap cascades app-wide without
  // requiring every callsite to be renamed in a single pass.
  static Color get bgCream => bgSurface;
  static Color get bgCreamLight => surfaceCard;
  static Color get tealPrimary => brandPrimary;
  static Color get tealDark => brandDeep;
  static Color get tealSoft => brandSoft;
  static Color get tealMuted => surfaceLow;
  static Color get cardWhite => surfaceCard;
  static Color get textDark => onSurface;
  static Color get textMuted => onSurfaceVariant;
  static Color get textSubtle => outline;
  static Color get border => outlineVariant;
  static Color get shadow => isDark ? _dShadow : _lShadow;

  // ── Warm shadow presets ──
  // Use these for cards, hero surfaces, and CTAs to keep the warm-glow
  // signature consistent across the app.
  static List<BoxShadow> get softWarm => [
    BoxShadow(
      color: isDark
          ? const Color(0x40000000)
          : const Color(0x14F28C55), // 8% warm orange
      blurRadius: 40,
      offset: const Offset(0, 20),
    ),
  ];

  static List<BoxShadow> get ctaGlow => [
    BoxShadow(
      color: isDark
          ? const Color(0x66FFB691)
          : const Color(0x4DF28C55), // 30% warm orange
      blurRadius: 24,
      spreadRadius: -6,
      offset: const Offset(0, 12),
    ),
  ];

  // ── Accent colors (purpose chips) — kept identical across modes ──
  static const Color leisureColor = Color(0xFFFF9F1C);
  static const Color adventureColor = Color(0xFF2EC4B6);
  static const Color businessColor = Color(0xFF3A86FF);
  static const Color culturalColor = Color(0xFF8338EC);

  static const Color weatherSunny = Color(0xFFFFB703);
  static const Color weatherRainy = Color(0xFF219EBC);
  static const Color weatherStormy = Color(0xFF495867);
  static const Color weatherCloudy = Color(0xFF8DA9C4);

  // ── Warning palette (countdown chips, traffic advisories) ──
  static const Color _lWarnSoft = Color(0xFFFFE4B5);
  static const Color _lWarnStrong = Color(0xFFB45309);
  static const Color _lWarnBg = Color(0xFFFFF3E0);
  static const Color _lWarnIcon = Color(0xFFD97706);
  static const Color _lWarnText = Color(0xFF92400E);

  static const Color _dWarnSoft = Color(0xFF3E2A12);
  static const Color _dWarnStrong = Color(0xFFFFC979);
  static const Color _dWarnBg = Color(0xFF2D1F0E);
  static const Color _dWarnIcon = Color(0xFFFFB347);
  static const Color _dWarnText = Color(0xFFFFD79A);

  static Color get warnSoft => isDark ? _dWarnSoft : _lWarnSoft;
  static Color get warnStrong => isDark ? _dWarnStrong : _lWarnStrong;
  static Color get warnBg => isDark ? _dWarnBg : _lWarnBg;
  static Color get warnIcon => isDark ? _dWarnIcon : _lWarnIcon;
  static Color get warnText => isDark ? _dWarnText : _lWarnText;

  // ── Weather card backgrounds (tinted toward the condition) ──
  static const Color _lWeatherSunnyBg = Color(0xFFFFF1D6);
  static const Color _lWeatherPartlyBg = Color(0xFFE5EEF5);
  static const Color _lWeatherCloudyBg = Color(0xFFE3E8EF);
  static const Color _lWeatherRainyBg = Color(0xFFD9EAF2);
  static const Color _lWeatherStormyBg = Color(0xFFC9CFD8);

  static const Color _dWeatherSunnyBg = Color(0xFF382B16);
  static const Color _dWeatherPartlyBg = Color(0xFF1F2D3D);
  static const Color _dWeatherCloudyBg = Color(0xFF262E3A);
  static const Color _dWeatherRainyBg = Color(0xFF1A3041);
  static const Color _dWeatherStormyBg = Color(0xFF161B23);

  static Color get weatherSunnyBg =>
      isDark ? _dWeatherSunnyBg : _lWeatherSunnyBg;
  static Color get weatherPartlyBg =>
      isDark ? _dWeatherPartlyBg : _lWeatherPartlyBg;
  static Color get weatherCloudyBg =>
      isDark ? _dWeatherCloudyBg : _lWeatherCloudyBg;
  static Color get weatherRainyBg =>
      isDark ? _dWeatherRainyBg : _lWeatherRainyBg;
  static Color get weatherStormyBg =>
      isDark ? _dWeatherStormyBg : _lWeatherStormyBg;
}
