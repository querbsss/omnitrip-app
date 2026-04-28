import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/colors.dart';
import '../../core/typography.dart';

class FaqItem {
  final String question;
  final String answer;
  const FaqItem(this.question, this.answer);
}

class FaqButton extends StatelessWidget {
  final String screenKey;
  final bool subtle;

  const FaqButton({
    super.key,
    required this.screenKey,
    this.subtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppColors.mode,
      builder: (context, _, __) => Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: () => _open(context),
          radius: 28,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: subtle
                  ? Colors.white.withValues(alpha: 0.9)
                  : AppColors.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Symbols.help_rounded,
              color: AppColors.brandDeep,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    final items = _faqs[screenKey] ?? const <FaqItem>[];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => _FaqSheet(items: items),
    );
  }
}

class _FaqSheet extends StatelessWidget {
  final List<FaqItem> items;
  const _FaqSheet({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
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
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Symbols.help_rounded,
                    size: 22,
                    color: AppColors.brandDeep,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Frequently Asked', style: AppType.headlineLg),
                      const SizedBox(height: 2),
                      Text(
                        'Quick answers for this screen',
                        style: AppType.bodySm,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Symbols.close_rounded, color: AppColors.outline),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _FaqTile(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final FaqItem item;
  const _FaqTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: AppColors.brandPrimary,
          collapsedIconColor: AppColors.outline,
          title: Text(
            item.question,
            style: AppType.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(item.answer, style: AppType.bodySm),
            ),
          ],
        ),
      ),
    );
  }
}

const Map<String, List<FaqItem>> _faqs = {
  'welcome': [
    FaqItem(
      'What is OmniTrip?',
      'A demo travel planner for the Philippines. Pick a destination, your '
          'starting city, and a date — OmniTrip drafts an itinerary with '
          'weather, traffic, packing tips, and a cost estimate.',
    ),
    FaqItem(
      'Do I need an account?',
      'Yes, but only so the app can remember your saved trips. Everything is '
          'stored on your device — no servers, no email lists.',
    ),
    FaqItem(
      'Is the app free?',
      'It is. OmniTrip is a class project, not a commercial service.',
    ),
    FaqItem(
      'Do I need internet?',
      'No. After the assets load once, the planner works fully offline.',
    ),
  ],
  'login': [
    FaqItem(
      'I forgot my password.',
      'There\'s no recovery flow yet — accounts live only on this device. '
          'You can register a new account with a different email anytime.',
    ),
    FaqItem(
      'Why do I need to log in?',
      'So your saved itineraries stick to your name and don\'t mix with '
          'someone else\'s on the same device.',
    ),
    FaqItem(
      'Are my details safe?',
      'Email and a hashed password live in your phone\'s local storage. '
          'Nothing is sent over the network.',
    ),
  ],
  'register': [
    FaqItem(
      'What information does OmniTrip collect?',
      'Just your name, email, and password — and only on this device. '
          'There\'s no analytics, no telemetry, no cloud sync.',
    ),
    FaqItem(
      'Can I use a fake email?',
      'For the demo, yes. The email is just an identifier; OmniTrip never '
          'sends mail.',
    ),
    FaqItem(
      'How strong should my password be?',
      'Pick at least 6 characters. The app stores a salted hash, not the '
          'raw password.',
    ),
  ],
  'planner': [
    FaqItem(
      'How is the cost estimated?',
      'OmniTrip measures the distance between your origin and destination, '
          'then prices bus / van / private drive / airfare based on real '
          'Philippine fare ranges. Lodging, food, and activities scale with '
          'the destination type and travel purpose.',
    ),
    FaqItem(
      'Why does "Coming from" matter so much?',
      'Distance is the biggest cost driver. Going to Tagaytay from Batangas '
          'City costs far less than going from Manila. Picking the right '
          'starting city makes the estimate honest.',
    ),
    FaqItem(
      'Why is "Private Vehicle" sometimes disabled?',
      'When your origin and destination are on different islands, you '
          'can\'t drive there directly — OmniTrip switches to airfare or '
          'ferry pricing instead.',
    ),
    FaqItem(
      'How accurate is the weather forecast?',
      'It\'s a rough simulation based on the Philippine climate zone of the '
          'destination and the month of travel. Treat it as a planning '
          'guide, not a meteorologist\'s call.',
    ),
    FaqItem(
      'Can I plan trips outside the Philippines?',
      'Not in this demo — OmniTrip is built around Philippine destinations '
          'and fares.',
    ),
  ],
  'results': [
    FaqItem(
      'Can I save this plan?',
      'Yes — tap "Save Trip" at the bottom of the results screen. It then '
          'appears under Booked Trips.',
    ),
    FaqItem(
      'How do I share the route?',
      'Tap the map link inside the route card to open it in your maps app. '
          'You can copy or share the link from there.',
    ),
    FaqItem(
      'Can I tweak the plan after generating it?',
      'Go back to the planner and change inputs — every regeneration is a '
          'fresh estimate. Saved trips can be edited from Booked Trips.',
    ),
  ],
  'booked': [
    FaqItem(
      'How do I edit a saved trip?',
      'Tap the menu (⋮) on a trip card and choose "Edit". You can change '
          'the date, origin, purpose, transport, and notes.',
    ),
    FaqItem(
      'Are my trips synced across devices?',
      'No — they\'re stored only on this device, tied to the account you\'re '
          'signed in with. Reinstalling the app clears them.',
    ),
    FaqItem(
      'Can I delete a trip?',
      'Yes — tap the menu on a trip and choose "Remove". You\'ll be asked to '
          'confirm.',
    ),
  ],
};
