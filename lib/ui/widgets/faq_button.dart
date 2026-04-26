import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/colors.dart';

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
    return IconButton(
      tooltip: 'FAQs',
      icon: Icon(
        HugeIcons.strokeRoundedHelpCircle,
        color: subtle ? AppColors.textMuted : AppColors.textDark,
      ),
      onPressed: () => _open(context),
    );
  }

  void _open(BuildContext context) {
    final items = _faqs[screenKey] ?? const <FaqItem>[];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.tealMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    HugeIcons.strokeRoundedHelpCircle,
                    size: 18,
                    color: AppColors.tealDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(HugeIcons.strokeRoundedCancel01),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
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
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: AppColors.tealDark,
          collapsedIconColor: AppColors.tealPrimary,
          title: Text(
            item.question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.35,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
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
