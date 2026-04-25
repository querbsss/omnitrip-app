import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/colors.dart';
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
            height: 96,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const _BarsArt(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onOpenMap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE7F1EC), Color(0xFFD7E4DD)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _RouteArt())),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tealPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        route.estimatedTrafficMin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 10,
                    bottom: 8,
                    child: Row(
                      children: [
                        Icon(HugeIcons.strokeRoundedMaps,
                            size: 14, color: AppColors.tealDark),
                        SizedBox(width: 4),
                        Text(
                          'Open Map',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tealDark,
                          ),
                        ),
                      ],
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
                    color: AppColors.tealPrimary.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(4),
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
      ..color = AppColors.tealDark.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
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

    final dot = Paint()..color = AppColors.tealDark;
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.85), 3.5, dot);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.25), 3.5, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
