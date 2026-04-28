import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import 'widgets/faq_button.dart';
import 'widgets/pill_button.dart';

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
      backgroundColor: AppColors.bgSurface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroBlock(
                  images: _carouselImages,
                  activeIndex: _index,
                ),
                Transform.translate(
                  offset: const Offset(0, -56),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _WelcomeCard(
                      caption: _captions[_index % _captions.length],
                      onGetStarted: () =>
                          Navigator.pushNamed(context, '/register'),
                      onSignIn: () =>
                          Navigator.pushNamed(context, '/login'),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: _Dots(
                    count: _carouselImages.length,
                    activeIndex: _index,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: const FaqButton(screenKey: 'welcome', subtle: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  final List<String> images;
  final int activeIndex;

  const _HeroBlock({required this.images, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.06, end: 1.0).animate(animation),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey<int>(activeIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[activeIndex % images.length]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  AppColors.bgSurface.withValues(alpha: 0.4),
                  AppColors.bgSurface,
                ],
                stops: const [0, 0.35, 0.85, 1],
              ),
            ),
          ),
          Positioned(
            top: 64,
            left: 24,
            right: 100,
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Symbols.travel_explore_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'OmniTrip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String caption;
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const _WelcomeCard({
    required this.caption,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppColors.softWarm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Symbols.auto_awesome_rounded,
                  size: 14,
                  color: AppColors.onSecondaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'NEW ADVENTURES AWAIT',
                  style: AppType.labelSm.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Your Journey\nStarts Here', style: AppType.headlineXl),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              caption,
              key: ValueKey(caption),
              style: AppType.bodyMd,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                child: _FeatureTile(
                  icon: Symbols.explore_rounded,
                  label: 'Curated\nGems',
                  iconColor: Color(0xFFF28C55),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FeatureTile(
                  icon: Symbols.cloud_off_rounded,
                  label: 'Works\nOffline',
                  iconColor: Color(0xFF586240),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PillButton(
            label: 'Get Started',
            icon: Symbols.arrow_forward_rounded,
            onPressed: onGetStarted,
          ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: onSignIn,
              behavior: HitTestBehavior.opaque,
              child: RichText(
                text: TextSpan(
                  style: AppType.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: AppType.labelMd.copyWith(
                        color: AppColors.brandDeep,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _FeatureTile({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(label, style: AppType.labelMd.copyWith(letterSpacing: 0)),
        ],
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
          width: active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.brandPrimary : AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
