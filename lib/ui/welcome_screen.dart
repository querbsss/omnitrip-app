import 'package:flutter/material.dart';

import '../core/colors.dart';
import 'widgets/omni_logo.dart';
import 'widgets/pill_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _collageEmojis = ['🏔️', '🏖️', '🌋', '🏝️', '🌅', '⛪'];
  static const _collageColors = [
    Color(0xFFB6D6CE),
    Color(0xFFEED9B0),
    Color(0xFFD8BFA8),
    Color(0xFFB8D4DC),
    Color(0xFFE8C5A8),
    Color(0xFFC9D9C0),
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
                    children: [
                      const SizedBox(height: 16),
                      _Collage(
                        height: isShort ? 140 : 180,
                        emojis: _collageEmojis,
                        colors: _collageColors,
                      ),
                      const SizedBox(height: 28),
                      const OmniLogo(size: 70, wordmarkSize: 32),
                      const SizedBox(height: 24),
                      const Text(
                        'Your Smart\nTravel Planner',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                          height: 1.15,
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
  final List<String> emojis;
  final List<Color> colors;
  const _Collage({
    required this.height,
    required this.emojis,
    required this.colors,
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
        color: colors[i % colors.length],
        borderRadius: radius,
      ),
      alignment: Alignment.center,
      child: Text(
        emojis[i % emojis.length],
        style: const TextStyle(fontSize: 30),
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
