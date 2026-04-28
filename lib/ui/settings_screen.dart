import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                _PillIcon(
                  icon: Symbols.arrow_back_rounded,
                  onTap: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Settings', style: AppType.headlineLg),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionLabel('ABOUT THIS APP'),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Symbols.shield_rounded,
              title: 'Offline by design',
              body:
                  'Your account, saved trips, and settings live only on this '
                  'device. Nothing is sent to a server.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Symbols.info_rounded,
              title: 'Demo build',
              body:
                  'OmniTrip is a class project. Fares, weather, and traffic '
                  'are simulated for demonstration purposes.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Symbols.travel_explore_rounded,
              title: 'Built for the Philippines',
              body:
                  'OmniTrip ships with 45 hand-curated destinations across '
                  'Luzon, Visayas, and Mindanao, plus realistic Philippine '
                  'fares, weather patterns, and travel routes.',
            ),
          ],
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        label,
        style: AppType.labelSm.copyWith(
          color: AppColors.outline,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoCard({
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.brandDeep, size: 20),
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
