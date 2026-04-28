import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/colors.dart';

// Translucent surface with backdrop blur — used for the login/register cards
// and any future glass surfaces (top bar overlays, modal sheets).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
    this.blur = 20,
    this.opacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final fill = AppColors.surfaceCard.withValues(alpha: opacity);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: AppColors.softWarm,
          ),
          child: child,
        ),
      ),
    );
  }
}
