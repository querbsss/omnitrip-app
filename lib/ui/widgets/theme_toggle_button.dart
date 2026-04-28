import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';
import '../../data/services/settings_service.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool subtle;
  const ThemeToggleButton({super.key, this.subtle = false});

  @override
  Widget build(BuildContext context) {
    // Subscribes directly to the mode notifier so this button rebuilds even
    // when an ancestor const-wraps it (e.g. const Positioned/Row in welcome
    // and login screens). Without this, Flutter skips the const subtree on
    // theme change, the captured isDark goes stale, and subsequent taps
    // re-send the same ThemeMode value — which ValueNotifier ignores.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppColors.mode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Material(
          color: Colors.transparent,
          child: InkResponse(
            onTap: () async {
              final next = isDark ? ThemeMode.light : ThemeMode.dark;
              AppColors.mode.value = next;
              await SettingsService().setThemeMode(next);
            },
            radius: 28,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: subtle
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.surfaceCard,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isDark ? Symbols.light_mode_rounded : Symbols.dark_mode_rounded,
                color: AppColors.brandDeep,
                size: 22,
                fill: isDark ? 1 : 0,
              ),
            ),
          ),
        );
      },
    );
  }
}
