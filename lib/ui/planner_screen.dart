import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../data/datasets/destinations.dart';
import '../data/models/destination.dart';
import '../data/models/origin.dart';
import '../data/services/auth_service.dart';
import '../data/services/plan_generator.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/app_drawer.dart';
import 'widgets/origin_picker_sheet.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Destination? _destination;
  DateTime? _date;
  String? _purpose;
  bool _weatherAware = true;
  bool _trafficAware = true;
  String? _firstName;

  Origin? _origin;
  int _travelers = 1;
  String _transportMode = 'commute';

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }

  Future<void> _loadFirstName() async {
    final email = await SessionService().getSessionEmail();
    if (email == null) return;
    final user = await AuthService().findByEmail(email);
    if (!mounted || user == null) return;
    final first = user.name.trim().split(RegExp(r'\s+')).first;
    setState(() => _firstName = first.isEmpty ? null : first);
  }

  Future<void> _pickDestination() async {
    final selected = await showModalBottomSheet<Destination>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => const _DestinationPickerSheet(),
    );
    if (selected != null) {
      setState(() {
        _destination = selected;
        if (!PlanGenerator.privateVehicleApplicable(selected, _origin)) {
          _transportMode = 'commute';
        }
      });
    }
  }

  Future<void> _pickOrigin() async {
    final selected = await showModalBottomSheet<Origin>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => const OriginPickerSheet(),
    );
    if (selected != null) {
      setState(() {
        _origin = selected;
        if (_destination != null &&
            !PlanGenerator.privateVehicleApplicable(_destination!, selected)) {
          _transportMode = 'commute';
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.brandPrimary,
            onPrimary: AppColors.onBrand,
            surface: AppColors.surfaceCard,
            onSurface: AppColors.onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _generate() {
    if (_destination == null) return _toast('Please pick a destination first.');
    if (_date == null) return _toast('Please choose a travel date.');
    if (_purpose == null) return _toast('Please choose a travel purpose.');
    if (_origin == null) return _toast('Please choose where you\'re coming from.');
    final plan = PlanGenerator().generate(
      destination: _destination!,
      travelDate: _date!,
      purpose: _purpose!,
      weatherAware: _weatherAware,
      trafficAware: _trafficAware,
      originLocation: _origin!.name,
      travelers: _travelers,
      transportMode: _transportMode,
    );
    Navigator.pushNamed(context, '/results', arguments: ResultsArgs(plan));
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.brandDeep,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
        content: Text(msg, style: TextStyle(color: AppColors.onBrand)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _date == null
        ? 'Pick a date'
        : DateFormat('EEE, MMM d').format(_date!);
    final destLabel = _destination?.name ?? 'Search destinations…';
    final privateAllowed = _destination == null ||
        PlanGenerator.privateVehicleApplicable(_destination!, _origin);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgSurface,
      drawer: const AppDrawer(currentRoute: '/planner'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _PlannerTopBar(
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              onBooked: () => Navigator.pushNamed(context, '/booked'),
            ),
            const SizedBox(height: 20),
            _GreetingHero(name: _firstName),
            const SizedBox(height: 6),
            Text(
              'Curate your next premium journey — weather, traffic, and '
              'cost rolled into one plan.',
              style: AppType.bodyMd,
            ),
            const SizedBox(height: 20),

            // Bento "WHERE TO?" + "DATES"
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: _BentoTile(
                      label: 'WHERE TO?',
                      onTap: _pickDestination,
                      child: Row(
                        children: [
                          Icon(
                            Symbols.explore_rounded,
                            color: AppColors.outline,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              destLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.bodyMd.copyWith(
                                color: _destination == null
                                    ? AppColors.outlineVariant
                                    : AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: _BentoTile(
                      label: 'DATES',
                      onTap: _pickDate,
                      child: Row(
                        children: [
                          Icon(
                            Symbols.calendar_today_rounded,
                            color: AppColors.brandPrimary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dateLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.titleLg.copyWith(
                                fontSize: 16,
                                color: _date == null
                                    ? AppColors.outlineVariant
                                    : AppColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            _SectionEyebrow('Your Travel Mood'),
            const SizedBox(height: 12),
            _MoodChipRow(
              selected: _purpose,
              onChanged: (v) => setState(() => _purpose = v),
            ),

            const SizedBox(height: 28),
            _SectionEyebrow('Trip Details'),
            const SizedBox(height: 12),
            _OriginCard(origin: _origin, onTap: _pickOrigin),
            const SizedBox(height: 12),
            _TravelersCard(
              count: _travelers,
              onChanged: (v) => setState(() => _travelers = v),
            ),
            const SizedBox(height: 12),
            _TransportCard(
              mode: _transportMode,
              privateAllowed: privateAllowed,
              onChanged: (v) => setState(() => _transportMode = v),
            ),

            const SizedBox(height: 28),
            _SectionEyebrow('Plan Options'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppColors.softWarm,
              ),
              child: Column(
                children: [
                  _OptionToggle(
                    icon: Symbols.cloud_rounded,
                    title: 'Include Weather Forecast',
                    subtitle: 'Daily highs, lows, and packing tips',
                    value: _weatherAware,
                    onChanged: (v) => setState(() => _weatherAware = v),
                  ),
                  Divider(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    height: 1,
                  ),
                  _OptionToggle(
                    icon: Symbols.traffic_rounded,
                    title: 'Check Traffic & Routes',
                    subtitle: 'Live map links and travel times',
                    value: _trafficAware,
                    onChanged: (v) => setState(() => _trafficAware = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _GenerateFab(onPressed: _generate),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _PlannerTopBar extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onBooked;

  const _PlannerTopBar({required this.onMenu, required this.onBooked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PillIcon(icon: Symbols.menu_rounded, onTap: onMenu),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'OmniTrip',
            style: AppType.titleLg.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        _PillIcon(icon: Symbols.event_note_rounded, onTap: onBooked),
      ],
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

class _GreetingHero extends StatefulWidget {
  final String? name;
  const _GreetingHero({required this.name});

  @override
  State<_GreetingHero> createState() => _GreetingHeroState();
}

class _GreetingHeroState extends State<_GreetingHero> {
  static const _templates = <String>[
    'Plan Your Escape, {name}',
    'Where to next, {name}?',
    'Let\'s map it out, {name}',
  ];

  int _idx = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() => _idx = (_idx + 1) % _templates.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name ?? 'Traveler';
    final text = _templates[_idx].replaceAll('{name}', name);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: Text(
        text,
        key: ValueKey<int>(_idx),
        style: AppType.headlineXl,
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback onTap;

  const _BentoTile({
    required this.label,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.softWarm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppType.labelSm.copyWith(color: AppColors.brandDeep),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  final String label;
  const _SectionEyebrow(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppType.labelSm.copyWith(
        color: AppColors.outline,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _MoodChipRow extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const _MoodChipRow({required this.selected, required this.onChanged});

  static const _moods = <_Mood>[
    _Mood('vacation', 'Vacation', Symbols.beach_access_rounded),
    _Mood('date_idea', 'Date Idea', Symbols.favorite_rounded),
    _Mood('school_business', 'School / Biz', Symbols.work_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final m in _moods)
          _MoodChip(
            mood: m,
            selected: selected == m.id,
            onTap: () => onChanged(m.id),
          ),
      ],
    );
  }
}

class _Mood {
  final String id;
  final String label;
  final IconData icon;
  const _Mood(this.id, this.label, this.icon);
}

class _MoodChip extends StatelessWidget {
  final _Mood mood;
  final bool selected;
  final VoidCallback onTap;

  const _MoodChip({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.secondaryContainer : AppColors.surfaceCard;
    final fg = selected
        ? AppColors.onSecondaryContainer
        : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: selected
              ? null
              : Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: -4,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(mood.icon, color: fg, size: 18, fill: selected ? 1 : 0),
            const SizedBox(width: 8),
            Text(
              mood.label,
              style: AppType.labelMd.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

class _OriginCard extends StatelessWidget {
  final Origin? origin;
  final VoidCallback onTap;
  const _OriginCard({required this.origin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final value = origin == null
        ? null
        : '${origin!.name}, ${origin!.province}';
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.softWarm,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.brandSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                Symbols.route_rounded,
                size: 22,
                color: AppColors.brandDeep,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMING FROM',
                    style: AppType.labelSm.copyWith(
                      color: AppColors.brandDeep,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'Select your starting city',
                    style: AppType.bodyMd.copyWith(
                      color: value == null
                          ? AppColors.outlineVariant
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

class _TravelersCard extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const _TravelersCard({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softWarm,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              Symbols.group_rounded,
              size: 22,
              color: AppColors.brandDeep,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRAVELERS',
                  style: AppType.labelSm.copyWith(
                    color: AppColors.brandDeep,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count == 1 ? 'Solo trip' : '$count travelers',
                  style: AppType.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Symbols.remove_rounded,
            enabled: count > 1,
            onTap: () => onChanged(count - 1),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: AppType.titleLg,
            ),
          ),
          _StepperButton(
            icon: Symbols.add_rounded,
            enabled: count < 20,
            onTap: () => onChanged(count + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: enabled ? onTap : null,
      radius: 22,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? AppColors.brandPrimary : AppColors.surfaceLow,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.onBrand : AppColors.outlineVariant,
        ),
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  final String mode;
  final bool privateAllowed;
  final ValueChanged<String> onChanged;

  const _TransportCard({
    required this.mode,
    required this.privateAllowed,
    required this.onChanged,
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
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Symbols.directions_bus_rounded,
                  size: 22,
                  color: AppColors.brandDeep,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRANSPORT',
                      style: AppType.labelSm.copyWith(
                        color: AppColors.brandDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'How are you getting there?',
                      style: AppType.bodySm,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TransportOption(
                  label: 'Public Commute',
                  icon: Symbols.directions_bus_rounded,
                  selected: mode == 'commute',
                  enabled: true,
                  onTap: () => onChanged('commute'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TransportOption(
                  label: 'Private Vehicle',
                  icon: Symbols.directions_car_rounded,
                  selected: mode == 'private',
                  enabled: privateAllowed,
                  onTap: () => onChanged('private'),
                ),
              ),
            ],
          ),
          if (!privateAllowed)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Symbols.info_rounded,
                    size: 14,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Private vehicle isn\'t practical here — fly or ferry only.',
                      style: AppType.bodySm.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
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

class _TransportOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _TransportOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.secondaryContainer
                : AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(999),
            border: selected
                ? null
                : Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? AppColors.onSecondaryContainer
                    : AppColors.brandDeep,
                fill: selected ? 1 : 0,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.labelMd.copyWith(
                    color: selected
                        ? AppColors.onSecondaryContainer
                        : AppColors.onSurface,
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

class _OptionToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OptionToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
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
                  style: AppType.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(subtitle, style: AppType.bodySm),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}

class _GenerateFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _GenerateFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: AppColors.ctaGlow,
        ),
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.onBrand,
          shape: const StadiumBorder(),
          icon: const Icon(Symbols.auto_awesome_rounded, fill: 1),
          label: const Text(
            'Generate Plan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.16,
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationPickerSheet extends StatefulWidget {
  const _DestinationPickerSheet();

  @override
  State<_DestinationPickerSheet> createState() =>
      _DestinationPickerSheetState();
}

class _DestinationPickerSheetState extends State<_DestinationPickerSheet> {
  String _query = '';
  String? _regionFilter;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    final filtered = Destinations.all.where((d) {
      if (_regionFilter != null && d.region != _regionFilter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return d.name.toLowerCase().contains(q) ||
          d.province.toLowerCase().contains(q) ||
          d.region.toLowerCase().contains(q);
    }).toList();

    final byRegion = <String, List<Destination>>{};
    for (final d in filtered) {
      byRegion.putIfAbsent(d.region, () => []).add(d);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: ConstrainedBox(
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
              padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose Destination',
                      style: AppType.headlineLg,
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Symbols.search_rounded,
                    color: AppColors.outline,
                  ),
                  hintText: 'Search city, province, region…',
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _RegionPill(
                    label: 'All',
                    selected: _regionFilter == null,
                    onTap: () => setState(() => _regionFilter = null),
                  ),
                  const SizedBox(width: 8),
                  for (final region in Destinations.regions) ...[
                    _RegionPill(
                      label: region,
                      selected: _regionFilter == region,
                      onTap: () => setState(() => _regionFilter = region),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                children: [
                  for (final region in Destinations.regions)
                    if (byRegion[region]?.isNotEmpty ?? false) ...[
                      if (_regionFilter == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Text(
                            region.toUpperCase(),
                            style: AppType.labelSm.copyWith(
                              color: AppColors.brandDeep,
                              letterSpacing: 1.2,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 6),
                      ...byRegion[region]!.map(
                        (d) => InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.pop(context, d),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceCard,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    d.emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.name,
                                        style: AppType.bodyMd.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      Text(d.province, style: AppType.bodySm),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Symbols.chevron_right_rounded,
                                  color: AppColors.outline,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No destinations match your search.',
                          style: AppType.bodySm,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RegionPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brandPrimary
              : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected ? AppColors.ctaGlow : null,
        ),
        child: Text(
          label,
          style: AppType.labelMd.copyWith(
            color: selected ? AppColors.onBrand : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
