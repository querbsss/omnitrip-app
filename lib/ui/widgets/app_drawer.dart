import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/profile_service.dart';
import '../../data/services/session_service.dart';
import 'user_avatar.dart';

/// The main navigation drawer used on the home and planner screens.
/// Header shows the avatar + name (loaded async); body links to Profile,
/// Settings, Help, About; footer has Log Out.
class AppDrawer extends StatefulWidget {
  /// Route the user is currently on; that drawer item is highlighted and
  /// tapping it just closes the drawer instead of pushing the same page.
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserModel? _user;
  String? _avatar;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Drawer is mounted once by Scaffold and reused across opens, so a
    // simple initState load would freeze the avatar/name. Subscribing to
    // the profile notifier lets edits on the Profile screen propagate
    // back here without requiring the parent to rebuild.
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
    if (!mounted) return;
    setState(() {
      _user = user;
      _avatar = avatar;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await SessionService().clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  // Top-level destinations are kept under /home (the post-login root) so
  // back from Planner/Booked returns to Home, and back from Home exits.
  // Sub-pages (Profile/Settings/Help/About) are pushed on top of whatever
  // the user was on, so their back button returns there.
  static const _topLevel = {'/planner', '/booked'};

  void _go(String route) {
    Navigator.pop(context); // close drawer
    if (route == widget.currentRoute) return;
    if (route == '/home') {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else if (_topLevel.contains(route)) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        ModalRoute.withName('/home'),
      );
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(
              loading: _loading,
              user: _user,
              avatar: _avatar,
            ),
            const SizedBox(height: 16),
            _DrawerItem(
              icon: Symbols.home_rounded,
              label: 'Home',
              selected: widget.currentRoute == '/home',
              onTap: () => _go('/home'),
            ),
            _DrawerItem(
              icon: Symbols.auto_awesome_rounded,
              label: 'Plan a Trip',
              selected: widget.currentRoute == '/planner',
              onTap: () => _go('/planner'),
            ),
            _DrawerItem(
              icon: Symbols.event_note_rounded,
              label: 'Booked Trips',
              selected: widget.currentRoute == '/booked',
              onTap: () => _go('/booked'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 12),
            _DrawerItem(
              icon: Symbols.person_rounded,
              label: 'Profile',
              onTap: () => _go('/profile'),
            ),
            _DrawerItem(
              icon: Symbols.settings_rounded,
              label: 'Settings',
              onTap: () => _go('/settings'),
            ),
            _DrawerItem(
              icon: Symbols.help_rounded,
              label: 'Help',
              onTap: () => _go('/help'),
            ),
            _DrawerItem(
              icon: Symbols.info_rounded,
              label: 'About Us',
              onTap: () => _go('/about'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 8),
            _DrawerItem(
              icon: Symbols.logout_rounded,
              label: 'Log Out',
              destructive: true,
              onTap: () async {
                Navigator.pop(context);
                await _logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final bool loading;
  final UserModel? user;
  final String? avatar;

  const _DrawerHeader({
    required this.loading,
    required this.user,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandFixedDim.withValues(alpha: 0.25),
            AppColors.brandSoft.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withValues(alpha: 0.18),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  UserAvatar(
                    emoji: avatar,
                    name: user?.name ?? '',
                    size: 56,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loading ? 'Loading…' : (user?.name ?? 'Traveler'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.titleLg,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'PREMIUM TRAVELER',
                  style: AppType.labelSm.copyWith(color: AppColors.brandDeep),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = destructive
        ? const Color(0xFFBA1A1A)
        : (selected ? AppColors.onBrand : AppColors.brandDeep);
    final labelColor = destructive
        ? const Color(0xFFBA1A1A)
        : AppColors.onSurface;
    final iconBg = destructive
        ? const Color(0xFFBA1A1A).withValues(alpha: 0.12)
        : (selected ? AppColors.brandPrimary : AppColors.brandSoft);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.brandSoft.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selected ? AppColors.ctaGlow : null,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppType.bodyMd.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
              if (!destructive)
                Icon(
                  Symbols.chevron_right_rounded,
                  size: 20,
                  color: AppColors.outlineVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
