import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../data/datasets/destinations.dart';
import '../data/models/destination.dart';
import '../data/services/auth_service.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/profile_service.dart';
import '../data/services/session_service.dart';
import 'widgets/app_drawer.dart';
import 'widgets/bottom_nav_pill.dart';
import 'widgets/section_header.dart';
import 'widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Curated highlights from the Destinations dataset — beach + island +
  // heritage spots that read as "iconic Philippines" for a class demo.
  static const List<String> _topDestinationIds = [
    'boracay',
    'el_nido',
    'siargao',
    'bohol',
    'coron',
    'cebu_city',
    'baguio',
    'vigan',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _firstName;
  String? _avatar;
  int _tripCount = 0;

  @override
  void initState() {
    super.initState();
    // Listen for avatar changes from the Profile screen so the greeting
    // card and AppBar avatar refresh automatically (the drawer-launched
    // navigation doesn't return to here, so .then((_) => _load()) on the
    // navigation call alone wouldn't catch every path).
    ProfileService.changes.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    ProfileService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final email = await SessionService().getSessionEmail();
    if (email == null || !mounted) return;
    final user = await AuthService().findByEmail(email);
    final avatar = await ProfileService().getAvatar(email);
    final trips = await BookedTripsService().all(email);
    if (!mounted) return;
    final first =
        user?.name.trim().split(RegExp(r'\s+')).firstOrNull ?? 'Traveler';
    setState(() {
      _firstName = first.isEmpty ? 'Traveler' : first;
      _avatar = avatar;
      _tripCount = trips.length;
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final tops = _topDestinationIds
        .map((id) => Destinations.byId(id))
        .toList(growable: false);
    final featured = tops.first;
    final recommended = tops.skip(1).take(4).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgSurface,
      drawer: const AppDrawer(currentRoute: '/home'),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _HeroBlock(
                firstName: _firstName,
                avatar: _avatar,
                greeting: _greeting(),
                destination: featured,
                onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                onAvatar: () =>
                    Navigator.pushNamed(context, '/profile').then((_) => _load()),
                onPlan: () => Navigator.pushNamed(context, '/planner'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(
                  title: 'Quick actions',
                  subtitle: tripCountSubtitle(),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _NavCard(
                        icon: Symbols.auto_awesome_rounded,
                        title: 'Plan a Trip',
                        subtitle: 'Build a smart itinerary',
                        accent: AppColors.brandPrimary,
                        onTap: () => Navigator.pushNamed(context, '/planner'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NavCard(
                        icon: Symbols.event_note_rounded,
                        title: 'Booked Trips',
                        subtitle: _tripCount == 0
                            ? 'No trips yet'
                            : '$_tripCount saved',
                        accent: AppColors.secondary,
                        onTap: () => Navigator.pushNamed(context, '/booked')
                            .then((_) => _load()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Top Destinations',
                  subtitle: 'Iconic places to visit in the Philippines',
                  actionLabel: 'See more',
                  onAction: () => Navigator.pushNamed(context, '/planner'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: tops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => _DestinationCard(
                    destination: tops[i],
                    onTap: () => Navigator.pushNamed(context, '/planner'),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(title: 'Recommended for You'),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BentoGrid(
                  destinations: recommended,
                  onTap: (_) => Navigator.pushNamed(context, '/planner'),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TipBanner(
                  icon: Symbols.tips_and_updates_rounded,
                  title: 'New here?',
                  body: 'Open the menu (top-left) for Profile, Settings, '
                      'Help, and About. Tap your avatar to change it.',
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BottomNavPill(current: BottomNavTab.home),
            ),
          ),
        ],
      ),
    );
  }

  String tripCountSubtitle() {
    if (_tripCount == 0) {
      return 'Tap "Plan a Trip" to begin your first journey';
    }
    return 'You\'ve curated $_tripCount trip${_tripCount == 1 ? '' : 's'} so far';
  }
}

// Hero block — image + dark gradient overlay + greeting + plan CTA pill on top.
// Mirrors the LuxeTravel "Hero Section" pattern with overlapping content below.
class _HeroBlock extends StatelessWidget {
  final String? firstName;
  final String? avatar;
  final String greeting;
  final Destination destination;
  final VoidCallback onMenu;
  final VoidCallback onAvatar;
  final VoidCallback onPlan;

  const _HeroBlock({
    required this.firstName,
    required this.avatar,
    required this.greeting,
    required this.destination,
    required this.onMenu,
    required this.onAvatar,
    required this.onPlan,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          // The featured destination is rendered as a soft tonal hero gradient
          // (no image asset — the dataset only ships emoji art). Keeps the
          // mockup's "rich hero" feel without breaking the offline-only rule.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.brandDeep,
                    AppColors.brandPrimary,
                    AppColors.brandFixedDim,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: 80,
                    child: Opacity(
                      opacity: 0.15,
                      child: Text(
                        destination.emoji,
                        style: const TextStyle(fontSize: 280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.transparent,
                    AppColors.bgSurface.withValues(alpha: 0.6),
                    AppColors.bgSurface,
                  ],
                  stops: const [0, 0.4, 0.85, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RoundIcon(
                        icon: Symbols.menu_rounded,
                        onTap: onMenu,
                        translucent: true,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                          child: UserAvatar(
                            emoji: avatar,
                            name: firstName ?? '',
                            size: 38,
                            border: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting.toUpperCase(),
                          style: AppType.labelSm.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hey ${firstName ?? 'Traveler'} 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.headlineXl.copyWith(
                            color: Colors.white,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Where to next?',
                          style: AppType.bodyMd.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: GestureDetector(
              onTap: onPlan,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: AppColors.softWarm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.search_rounded,
                      color: AppColors.outline,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search destinations...',
                        style: AppType.bodyMd.copyWith(
                          color: AppColors.outlineVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.ctaGlow,
                      ),
                      child: Icon(
                        Symbols.tune_rounded,
                        color: AppColors.onBrand,
                        size: 18,
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

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool translucent;

  const _RoundIcon({
    required this.icon,
    required this.onTap,
    this.translucent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: translucent
                ? Colors.white.withValues(alpha: 0.18)
                : AppColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: translucent ? 0.3 : 0),
            ),
          ),
          child: Icon(
            icon,
            color: translucent ? Colors.white : AppColors.brandDeep,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 138,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.softWarm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: accent, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: AppType.titleLg.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.bodySm,
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _DestinationCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 178,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.softWarm,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.brandFixedDim,
                        AppColors.brandPrimary,
                        AppColors.brandDeep,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: -8,
                child: Opacity(
                  opacity: 0.25,
                  child: Text(
                    destination.emoji,
                    style: const TextStyle(fontSize: 140),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 60, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          destination.region.toUpperCase(),
                          style: AppType.labelSm.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.titleLg.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.star_rounded,
                        size: 14,
                        color: AppColors.brandPrimary,
                        fill: 1,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '4.${(destination.name.length % 9) + 1}',
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
    );
  }
}

// 2-col bento — 1 wide tile across the top, 2 squares below.
class _BentoGrid extends StatelessWidget {
  final List<Destination> destinations;
  final ValueChanged<Destination> onTap;

  const _BentoGrid({required this.destinations, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) return const SizedBox.shrink();
    final wide = destinations[0];
    final left = destinations.length > 1 ? destinations[1] : destinations[0];
    final right = destinations.length > 2 ? destinations[2] : destinations[0];
    return Column(
      children: [
        _BentoTile(
          destination: wide,
          height: 180,
          tag: 'BEST VALUE',
          onTap: () => onTap(wide),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BentoTile(
                destination: left,
                height: 200,
                onTap: () => onTap(left),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BentoTile(
                destination: right,
                height: 200,
                onTap: () => onTap(right),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final Destination destination;
  final double height;
  final String? tag;
  final VoidCallback onTap;

  const _BentoTile({
    required this.destination,
    required this.height,
    required this.onTap,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.85),
                        AppColors.brandDeep,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -20,
                top: 0,
                child: Opacity(
                  opacity: 0.18,
                  child: Text(
                    destination.emoji,
                    style: TextStyle(fontSize: height * 0.9),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
              ),
              if (tag != null)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag!,
                      style: AppType.labelSm.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      destination.region.toUpperCase(),
                      style: AppType.labelSm.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.headlineLg.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TipBanner({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.brandSoft.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandFixedDim.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.brandDeep, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.titleLg.copyWith(
                    fontSize: 15,
                    color: AppColors.brandDeep,
                  ),
                ),
                const SizedBox(height: 4),
                Text(body, style: AppType.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
