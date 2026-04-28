import 'package:flutter/material.dart';

import '../../core/colors.dart';

/// Circular avatar that shows the user's chosen emoji, or initials when no
/// emoji is set. Used on the home screen, drawer header, and profile screen.
class UserAvatar extends StatelessWidget {
  final String? emoji;
  final String name;
  final double size;
  final bool border;

  const UserAvatar({
    super.key,
    required this.emoji,
    required this.name,
    this.size = 48,
    this.border = true,
  });

  String _initials() {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasEmoji = emoji != null && emoji!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.brandSoft,
        shape: BoxShape.circle,
        border: border
            ? Border.all(
                color: AppColors.brandFixedDim.withValues(alpha: 0.6),
                width: 2,
              )
            : null,
        boxShadow: border
            ? [
                BoxShadow(
                  color: AppColors.brandPrimary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: hasEmoji
          ? Text(
              emoji!,
              style: TextStyle(fontSize: size * 0.5),
            )
          : Text(
              _initials(),
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w800,
                color: AppColors.brandDeep,
                letterSpacing: -0.2,
              ),
            ),
    );
  }
}
