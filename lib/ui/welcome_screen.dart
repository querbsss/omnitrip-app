import 'package:flutter/material.dart';

import '../core/colors.dart';
import 'widgets/pill_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _collageImages = <String>[
    'assets/images/login_page/background/pexels-abinaya-palanichamy-2160399839-36696891.jpg',
    'assets/images/login_page/background/pexels-alxs-6552924.jpg',
    'assets/images/login_page/background/pexels-illiad-8705705.jpg',
    'assets/images/login_page/background/pexels-jermaine-boyles-26651699-6797920.jpg',
    'assets/images/login_page/background/pexels-jobzky-8022579.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isShort = constraints.maxHeight < 640;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      _Collage(
                        height: isShort ? 150 : 200,
                        images: _collageImages,
                      ),
                      const SizedBox(height: 20),
                      Transform.translate(
                        offset: const Offset(-3.5, 0),
                        child: Center(
                          child: Image.asset(
                            'assets/images/login_page/logo/logo_omnitrip.png',
                            width: 280,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: const Center(
                          child: Text(
                            'Your Smart\nTravel Planner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Plan trips with weather, traffic, and local insights.\nAll in One Place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _Dots(activeIndex: 0),
                      const Spacer(),
                      PillButton(
                        label: 'Get Started',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: AppColors.tealDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Collage extends StatelessWidget {
  final double height;
  final List<String> images;
  const _Collage({
    required this.height,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(child: _tile(0, BorderRadius.circular(18))),
                const SizedBox(height: 8),
                Expanded(child: _tile(1, BorderRadius.circular(18))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _tile(2, BorderRadius.circular(20)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _tile(3, BorderRadius.circular(18))),
                const SizedBox(height: 8),
                Expanded(child: _tile(4, BorderRadius.circular(18))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(int i, BorderRadius radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(images[i % images.length]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int activeIndex;
  const _Dots({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.tealPrimary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
