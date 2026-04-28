import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';

// Floating glass pill nav (Home / Explore / Trips / Profile).
// Sits at the bottom of structural screens (Home, Results, Booked, Profile).
// Selected item shows the warm CTA glow; unselected items are muted outlines.
class BottomNavPill extends StatelessWidget {
  final BottomNavTab current;
  final ValueChanged<BottomNavTab>? onTabChanged;

  const BottomNavPill({
    super.key,
    required this.current,
    this.onTabChanged,
  });

  void _navigate(BuildContext context, BottomNavTab tab) {
    if (tab == current) return;
    if (onTabChanged != null) {
      onTabChanged!(tab);
      return;
    }
    final route = switch (tab) {
      BottomNavTab.home => '/home',
      BottomNavTab.explore => '/planner',
      BottomNavTab.trips => '/booked',
      BottomNavTab.profile => '/profile',
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the pill in a Row(mainAxisAlignment: center) instead of Center —
    // Center expands to fill its parent vertically, which collapses the
    // Align(bottomCenter) wrapper above and parks the pill mid-screen.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  boxShadow: AppColors.softWarm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final tab in BottomNavTab.values) ...[
                      _NavButton(
                        tab: tab,
                        selected: tab == current,
                        onTap: () => _navigate(context, tab),
                      ),
                      if (tab != BottomNavTab.values.last)
                        const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BottomNavTab { home, explore, trips, profile }

extension on BottomNavTab {
  IconData get icon => switch (this) {
    BottomNavTab.home => Symbols.home_rounded,
    BottomNavTab.explore => Symbols.explore_rounded,
    BottomNavTab.trips => Symbols.event_note_rounded,
    BottomNavTab.profile => Symbols.person_rounded,
  };
}

class _NavButton extends StatelessWidget {
  final BottomNavTab tab;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            shape: BoxShape.circle,
            boxShadow: AppColors.ctaGlow,
          ),
          child: Icon(tab.icon, color: AppColors.onBrand, size: 24, fill: 1),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(tab.icon, color: AppColors.outline, size: 24),
      ),
    );
  }
}
