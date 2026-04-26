import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/colors.dart';
import '../../data/services/settings_service.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool subtle;
  const ThemeToggleButton({super.key, this.subtle = false});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: Icon(
        isDark
            ? HugeIcons.strokeRoundedSun03
            : HugeIcons.strokeRoundedMoon02,
        color: subtle ? AppColors.textMuted : AppColors.textDark,
      ),
      onPressed: () async {
        final next = isDark ? ThemeMode.light : ThemeMode.dark;
        AppColors.mode.value = next;
        await SettingsService().setThemeMode(next);
      },
    );
  }
}
