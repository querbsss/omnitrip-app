import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';

class InputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final String? value;
  final VoidCallback onTap;
  final bool isError;

  const InputCard({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.onTap,
    this.value,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isError
                ? const Color(0xFFBA1A1A)
                : AppColors.outlineVariant.withValues(alpha: 0.4),
            width: isError ? 1.5 : 1,
          ),
          boxShadow: AppColors.softWarm,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.brandSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.brandDeep, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppType.labelSm.copyWith(
                      color: AppColors.brandDeep,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasValue ? value! : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.bodyMd.copyWith(
                      color: hasValue
                          ? AppColors.onSurface
                          : AppColors.outlineVariant,
                      fontWeight:
                          hasValue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Symbols.chevron_right_rounded,
              color: AppColors.outline,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
