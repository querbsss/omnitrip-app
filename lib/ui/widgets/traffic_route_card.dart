import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../data/models/route_info.dart';

class TrafficRouteCard extends StatelessWidget {
  final RouteInfo route;
  final VoidCallback onOpenMap;

  const TrafficRouteCard({
    super.key,
    required this.route,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.softWarm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRAFFIC',
                  style: AppType.labelSm.copyWith(
                    color: AppColors.brandDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(child: const _BarsArt()),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onOpenMap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.brandSoft,
                    AppColors.brandFixedDim.withValues(alpha: 0.6),
                  ],
                ),
                boxShadow: AppColors.softWarm,
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _RouteArt())),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: AppColors.ctaGlow,
                      ),
                      child: Text(
                        route.estimatedTrafficMin,
                        style: AppType.labelMd.copyWith(
                          color: AppColors.onBrand,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.map_rounded,
                            size: 14,
                            color: AppColors.brandDeep,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Open Map',
                            style: AppType.labelMd.copyWith(
                              color: AppColors.brandDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BarsArt extends StatelessWidget {
  const _BarsArt();

  @override
  Widget build(BuildContext context) {
    final heights = [0.4, 0.7, 0.55, 0.85, 0.6, 0.95, 0.7, 0.45];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final h in heights)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FractionallySizedBox(
                heightFactor: h,
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.brandPrimary,
                        AppColors.brandDeep,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RouteArt extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandDeep.withValues(alpha: 0.55)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.4,
        size.width * 0.55,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.7,
        size.width * 0.9,
        size.height * 0.25,
      );
    canvas.drawPath(path, paint);

    final dot = Paint()..color = AppColors.brandDeep;
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.85), 4, dot);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.25), 4, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
