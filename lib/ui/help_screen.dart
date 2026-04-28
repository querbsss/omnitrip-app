import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _topics = <_HelpTopic>[
    _HelpTopic(
      icon: Symbols.location_on_rounded,
      title: 'How do I plan a trip?',
      body:
          'Open the planner, pick a destination, choose your starting city, '
          'set the date, then tap "Generate Plan". OmniTrip drafts an '
          'itinerary, an estimated cost, and weather and traffic notes.',
    ),
    _HelpTopic(
      icon: Symbols.payments_rounded,
      title: 'How is the cost calculated?',
      body:
          'OmniTrip measures the distance between your origin and destination, '
          'then prices bus / van / private vehicle / airfare based on real '
          'Philippine fare ranges. Lodging, food, and activities scale with '
          'the destination type and travel purpose.',
    ),
    _HelpTopic(
      icon: Symbols.bookmark_rounded,
      title: 'How do I save or edit a trip?',
      body:
          'After a plan is generated, tap "Save Trip". Saved trips show up '
          'under Booked Trips, where you can tap the menu (⋮) to edit or '
          'remove a trip.',
    ),
    _HelpTopic(
      icon: Symbols.directions_car_rounded,
      title: 'Why is "Private Vehicle" sometimes disabled?',
      body:
          'When your origin and destination are on different islands, you '
          'can\'t drive there directly. OmniTrip switches to airfare or '
          'ferry pricing instead.',
    ),
    _HelpTopic(
      icon: Symbols.cloud_rounded,
      title: 'How accurate is the weather forecast?',
      body:
          'It\'s a rough simulation based on the climate zone of the '
          'destination and the month of travel. Treat it as a planning '
          'guide, not a meteorologist\'s call.',
    ),
    _HelpTopic(
      icon: Symbols.shield_rounded,
      title: 'Where is my data stored?',
      body:
          'Email, hashed password, saved trips, and theme preference are kept '
          'in your phone\'s local storage. Nothing is sent over the network. '
          'Reinstalling the app clears everything.',
    ),
    _HelpTopic(
      icon: Symbols.lock_rounded,
      title: 'I forgot my password.',
      body:
          'There\'s no recovery flow yet — accounts live only on this device. '
          'You can register a new account with a different email anytime.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: _topics.length + 2,
          separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 24 : 12),
          itemBuilder: (_, i) {
            if (i == 0) {
              return Row(
                children: [
                  _PillIcon(
                    icon: Symbols.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HELP CENTER',
                          style: AppType.labelSm.copyWith(
                            color: AppColors.outline,
                          ),
                        ),
                        Text(
                          'Frequently Asked',
                          style: AppType.headlineLg,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (i == 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Quick answers about how OmniTrip works.',
                  style: AppType.bodySm,
                ),
              );
            }
            return _HelpTile(topic: _topics[i - 2]);
          },
        ),
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

class _HelpTopic {
  final IconData icon;
  final String title;
  final String body;
  const _HelpTopic({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _HelpTile extends StatelessWidget {
  final _HelpTopic topic;
  const _HelpTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softWarm,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.brandPrimary,
          collapsedIconColor: AppColors.outline,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(topic.icon, size: 20, color: AppColors.brandDeep),
          ),
          title: Text(
            topic.title,
            style: AppType.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(topic.body, style: AppType.bodySm),
            ),
          ],
        ),
      ),
    );
  }
}
