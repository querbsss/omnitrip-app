import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/colors.dart';

class AnimatedLoginBackground extends StatefulWidget {
  const AnimatedLoginBackground({super.key});

  @override
  State<AnimatedLoginBackground> createState() =>
      _AnimatedLoginBackgroundState();
}

class _Island {
  final String image;
  final double dx;
  final double dy;
  final double size;
  final double phase;
  final double amp;

  const _Island({
    required this.image,
    required this.dx,
    required this.dy,
    required this.size,
    required this.phase,
    required this.amp,
  });
}

class _AnimatedLoginBackgroundState extends State<AnimatedLoginBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _didPrecache = false;

  static const _islands = <_Island>[
    _Island(
      image:
          'assets/images/login_page/background/pexels-abinaya-palanichamy-2160399839-36696891.jpg',
      dx: 0.04,
      dy: 0.04,
      size: 110,
      phase: 0.00,
      amp: 14,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-alxs-6552924.jpg',
      dx: 0.70,
      dy: 0.02,
      size: 95,
      phase: 0.18,
      amp: 12,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-illiad-8705705.jpg',
      dx: 0.82,
      dy: 0.34,
      size: 80,
      phase: 0.36,
      amp: 10,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-jermaine-boyles-26651699-6797920.jpg',
      dx: -0.04,
      dy: 0.42,
      size: 90,
      phase: 0.54,
      amp: 16,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-jobzky-8022579.jpg',
      dx: 0.02,
      dy: 0.78,
      size: 105,
      phase: 0.66,
      amp: 14,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-maxmishin-10046458.jpg',
      dx: 0.74,
      dy: 0.74,
      size: 100,
      phase: 0.82,
      amp: 12,
    ),
    _Island(
      image:
          'assets/images/login_page/background/pexels-sd-creatives-ph-287419999-18377976.jpg',
      dx: 0.42,
      dy: 0.92,
      size: 85,
      phase: 0.92,
      amp: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 9),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _didPrecache = true;
      for (final island in _islands) {
        precacheImage(AssetImage(island.image), context);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                for (final island in _islands)
                  _buildIsland(island, _ctrl.value, w, h),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIsland(_Island island, double t, double w, double h) {
    final p = (t + island.phase) % 1.0;
    final radians = p * 2 * math.pi;
    final dy = math.sin(radians) * island.amp;
    final dx = math.cos(radians) * island.amp * 0.35;
    final angle = math.sin(radians) * 0.05;

    return Positioned(
      left: island.dx * w + dx,
      top: island.dy * h + dy,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: island.size,
          height: island.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.tealDark.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(island.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
