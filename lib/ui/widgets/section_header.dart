import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';

// Title + optional subtitle + optional trailing "View all" link.
// Standardises the section-header rhythm across Home, Results, Planner.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppType.headlineLg),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: AppType.bodySm),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Text(
                actionLabel!,
                style: AppType.labelMd.copyWith(color: AppColors.brandDeep),
              ),
            ),
          ),
      ],
    );
  }
}
