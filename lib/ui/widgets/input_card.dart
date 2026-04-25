import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/colors.dart';

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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isError
                ? Colors.redAccent
                : AppColors.border,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.tealMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.tealPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasValue ? value! : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: hasValue
                          ? AppColors.tealDark
                          : AppColors.textMuted,
                      fontWeight:
                          hasValue ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textSubtle, size: 20),
          ],
        ),
      ),
    );
  }
}
