import 'package:flutter/material.dart';

import '../../core/colors.dart';

class OmniLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final double wordmarkSize;
  final Color? wordmarkColor;

  const OmniLogo({
    super.key,
    this.size = 56,
    this.showWordmark = true,
    this.wordmarkSize = 26,
    this.wordmarkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _LogoPainter()),
        ),
        if (showWordmark) ...[
          const SizedBox(width: 8),
          Text(
            'OmniTrip',
            style: TextStyle(
              fontSize: wordmarkSize,
              fontWeight: FontWeight.w700,
              color: wordmarkColor ?? AppColors.tealPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // outer globe
    final globe = Paint()
      ..color = AppColors.tealPrimary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, globe);

    // continents (decorative cream blobs)
    final cream = Paint()..color = AppColors.bgCream;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.35, center.dy - radius * 0.15),
        width: radius * 0.45,
        height: radius * 0.55,
      ),
      cream,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.3, center.dy + radius * 0.25),
        width: radius * 0.4,
        height: radius * 0.4,
      ),
      cream,
    );

    // compass needle
    final needle = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;
    final tip1 = Offset(center.dx, center.dy - radius * 0.55);
    final tip2 = Offset(center.dx, center.dy + radius * 0.55);
    canvas.drawLine(tip1, tip2, needle);

    // small location pin accent
    final pin = Paint()..color = const Color(0xFFE85D5D);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.7, center.dy - radius * 0.7),
      radius * 0.18,
      pin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
