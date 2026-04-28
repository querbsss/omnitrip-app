import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _PillIcon(
                    icon: Symbols.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('About Us', style: AppType.headlineLg),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _BrandHero(),
              const SizedBox(height: 24),
              const _AboutCard(
                icon: Symbols.auto_awesome_rounded,
                title: 'What is OmniTrip?',
                body:
                    'A demo travel planner for the Philippines. Pick a '
                    'destination, your starting city, and a date — OmniTrip '
                    'drafts an itinerary with weather, traffic, packing tips, '
                    'and a cost estimate. Everything works offline.',
              ),
              const SizedBox(height: 12),
              const _AboutCard(
                icon: Symbols.school_rounded,
                title: 'Built for class',
                body:
                    'OmniTrip is a class project from a student at Batangas '
                    'State University. It\'s not a commercial service — fares '
                    'and forecasts are simulated to demonstrate the planning '
                    'flow.',
              ),
              const SizedBox(height: 12),
              const _AboutCard(
                icon: Symbols.code_rounded,
                title: 'Built with',
                body:
                    'Flutter and Dart for the UI, shared_preferences for '
                    'on-device storage, Material Symbols for the icon set, '
                    'and Google Fonts (Plus Jakarta Sans) for typography.',
              ),
              const SizedBox(height: 12),
              const _AboutCard(
                icon: Symbols.shield_rounded,
                title: 'Privacy',
                body:
                    'Your account, saved trips, and theme preference live '
                    'only on this device. Nothing is sent to a server, and '
                    'there is no analytics or telemetry.',
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  'OmniTrip v1.0.0  ·  Demo build',
                  style: AppType.labelMd.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _PillIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 26,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Icon(icon, color: AppColors.brandDeep, size: 22),
        ),
      ),
    );
  }
}

class _BrandHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandFixedDim.withValues(alpha: 0.3),
            AppColors.brandSoft.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: AppColors.ctaGlow,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Symbols.travel_explore_rounded,
                  size: 34,
                  color: AppColors.onBrand,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'OmniTrip',
                style: AppType.headlineXl.copyWith(letterSpacing: -0.6),
              ),
              const SizedBox(height: 4),
              Text(
                'Your Smart Travel Planner',
                style: AppType.bodyMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _AboutCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softWarm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.brandDeep, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(body, style: AppType.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
