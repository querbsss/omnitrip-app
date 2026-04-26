import 'dart:async';

import 'package:flutter/material.dart';

import '../core/colors.dart';
import 'widgets/faq_button.dart';
import 'widgets/pill_button.dart';
import 'widgets/theme_toggle_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const List<String> _carouselImages = [
    'assets/images/login_page/background/pexels-abinaya-palanichamy-2160399839-36696891.jpg',
    'assets/images/login_page/background/pexels-alxs-6552924.jpg',
    'assets/images/login_page/background/pexels-illiad-8705705.jpg',
    'assets/images/login_page/background/pexels-jermaine-boyles-26651699-6797920.jpg',
    'assets/images/login_page/background/pexels-jobzky-8022579.jpg',
    'assets/images/login_page/background/pexels-maxmishin-10046458.jpg',
    'assets/images/login_page/background/pexels-sd-creatives-ph-287419999-18377976.jpg',
  ];

  static const List<String> _captions = [
    'Plan trips with weather, traffic, and local insights.',
    'Discover hidden gems across the Philippines.',
    'Estimate costs from your real starting city.',
    'Save your itineraries for later — all offline.',
    'Built for students, travelers, and dreamers.',
    'From Batanes to Tawi-Tawi — all in one place.',
    'Smarter trips, in just a few taps.',
  ];

  int _index = 0;
  Timer? _timer;
  bool _didPrecache = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _carouselImages.length);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _didPrecache = true;
      for (final path in _carouselImages) {
        precacheImage(AssetImage(path), context);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isShort = constraints.maxHeight < 640;
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          _ImageCarousel(
                            height: isShort ? 200 : 260,
                            images: _carouselImages,
                            activeIndex: _index,
                          ),
                          const SizedBox(height: 18),
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
                          Transform.translate(
                            offset: const Offset(0, -8),
                            child: Center(
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 450),
                            child: Padding(
                              key: ValueKey<int>(_index),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: Text(
                                _captions[_index % _captions.length],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _Dots(
                            count: _carouselImages.length,
                            activeIndex: _index,
                          ),
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
                            child: Text(
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
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaqButton(screenKey: 'welcome'),
                    ThemeToggleButton(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final double height;
  final List<String> images;
  final int activeIndex;

  const _ImageCarousel({
    required this.height,
    required this.images,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.04, end: 1.0).animate(animation),
            child: child,
          ),
        ),
        child: _Hero(
          key: ValueKey<int>(activeIndex),
          path: images[activeIndex % images.length],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final String path;
  const _Hero({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.bgCream.withValues(alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int activeIndex;
  const _Dots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
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
