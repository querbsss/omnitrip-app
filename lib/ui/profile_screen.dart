import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../data/models/user.dart';
import '../data/services/auth_service.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/profile_service.dart';
import '../data/services/session_service.dart';
import 'widgets/bottom_nav_pill.dart';
import 'widgets/pill_button.dart';
import 'widgets/user_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profile = ProfileService();
  UserModel? _user;
  String? _avatar;
  int _tripCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final email = await SessionService().getSessionEmail();
    if (email == null || !mounted) return;
    final user = await AuthService().findByEmail(email);
    final trips = await BookedTripsService().all(email);
    final avatar = await _profile.getAvatar(email);
    if (!mounted) return;
    setState(() {
      _user = user;
      _avatar = avatar;
      _tripCount = trips.length;
      _loading = false;
    });
  }

  Future<void> _pickAvatar() async {
    if (_user == null) return;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => _AvatarPickerSheet(currentAvatar: _avatar),
    );
    if (selected == null || !mounted) return;
    await _profile.setAvatar(_user!.email, selected);
    if (!mounted) return;
    setState(() => _avatar = selected);
  }

  Future<void> _logout() async {
    await SessionService().clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Stack(
        children: [
          SafeArea(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.brandPrimary,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                    children: [
                      Text(
                        'Profile',
                        style: AppType.headlineLg,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: _ProfileHeader(
                          user: _user,
                          avatar: _avatar,
                          onPickAvatar: _pickAvatar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              icon: Symbols.event_note_rounded,
                              label: 'Saved Trips',
                              value: '$_tripCount',
                              accent: AppColors.brandPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              icon: Symbols.shield_rounded,
                              label: 'Stored',
                              value: 'On device',
                              accent: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _LinkRow( 
                        icon: Symbols.settings_rounded,
                        title: 'Settings',
                        subtitle: 'Theme, preferences',
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                      const SizedBox(height: 10),
                      _LinkRow(
                        icon: Symbols.help_rounded,
                        title: 'Help',
                        subtitle: 'FAQs and how-tos',
                        onTap: () => Navigator.pushNamed(context, '/help'),
                      ),
                      const SizedBox(height: 10),
                      _LinkRow(
                        icon: Symbols.info_rounded,
                        title: 'About OmniTrip',
                        subtitle: 'Credits and info',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      const SizedBox(height: 28),
                      PillButton(
                        label: 'Log Out',
                        icon: Symbols.logout_rounded,
                        onPressed: _logout,
                      ),
                    ],
                  ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BottomNavPill(current: BottomNavTab.profile),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _PillIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 26,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Icon(icon, color: AppColors.brandDeep, size: 22),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel? user;
  final String? avatar;
  final VoidCallback onPickAvatar;

  const _ProfileHeader({
    required this.user,
    required this.avatar,
    required this.onPickAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandFixedDim.withValues(alpha: 0.3),
            AppColors.brandSoft.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserAvatar(
                    emoji: avatar,
                    name: user?.name ?? '',
                    size: 96,
                  ),
                  Material(
                    color: AppColors.brandPrimary,
                    shape: const CircleBorder(),
                    elevation: 0,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onPickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: AppColors.ctaGlow,
                        ),
                        child: Icon(
                          Symbols.edit_rounded,
                          size: 16,
                          color: AppColors.onBrand,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                user?.name ?? 'Traveler',
                textAlign: TextAlign.center,
                style: AppType.headlineLg,
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                textAlign: TextAlign.center,
                style: AppType.bodySm,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
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

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softWarm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: accent),
          ),
          const SizedBox(height: 12),
          Text(
            label.toUpperCase(),
            style: AppType.labelSm.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppType.titleLg.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.softWarm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brandSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: AppColors.brandDeep),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppType.bodyMd.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(subtitle, style: AppType.bodySm),
                ],
              ),
            ),
            Icon(
              Symbols.chevron_right_rounded,
              color: AppColors.outline,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPickerSheet extends StatelessWidget {
  final String? currentAvatar;
  const _AvatarPickerSheet({required this.currentAvatar});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Pick your avatar', style: AppType.headlineLg),
                ),
                IconButton(
                  icon: Icon(
                    Symbols.close_rounded,
                    color: AppColors.outline,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              'It shows on your home screen and profile.',
              style: AppType.bodySm,
            ),
          ),
          Flexible(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: [
                for (final emoji in ProfileService.avatarChoices)
                  _AvatarTile(
                    emoji: emoji,
                    selected: emoji == currentAvatar,
                    onTap: () => Navigator.pop(context, emoji),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarTile extends StatelessWidget {
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _AvatarTile({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSoft : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? Border.all(color: AppColors.brandPrimary, width: 2)
              : null,
          boxShadow: selected ? AppColors.ctaGlow : null,
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
