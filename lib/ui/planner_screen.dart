import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../data/datasets/destinations.dart';
import '../data/models/destination.dart';
import '../data/models/origin.dart';
import '../data/services/auth_service.dart';
import '../data/services/plan_generator.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/faq_button.dart';
import 'widgets/input_card.dart';
import 'widgets/origin_picker_sheet.dart';
import 'widgets/pill_button.dart';
import 'widgets/purpose_card.dart';
import 'widgets/theme_toggle_button.dart';
import 'widgets/toggle_row.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
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
      backgroundColor: AppColors.bgCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
      backgroundColor: AppColors.bgCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
          colorScheme: ColorScheme.light(
            primary: AppColors.tealPrimary,
            onPrimary: Colors.white,
            surface: AppColors.cardWhite,
            onSurface: AppColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _generate() {
    if (_destination == null) {
      _toast('Please pick a destination first.');
      return;
    }
    if (_date == null) {
      _toast('Please choose a travel date.');
      return;
    }
    if (_purpose == null) {
      _toast('Please choose a travel purpose.');
      return;
    }
    if (_origin == null) {
      _toast('Please choose where you\'re coming from.');
      return;
    }
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
        backgroundColor: AppColors.tealDark,
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
      ),
    );
  }

  Future<void> _logout() async {
    await SessionService().clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _date == null
        ? null
        : DateFormat('EEE, MMM d, y').format(_date!);
    final destLabel = _destination == null
        ? null
        : '${_destination!.name}, Philippines';

    final purposeHeading = _destination == null
        ? 'Select Travel Purpose'
        : 'Select Travel Purpose:  [${_destination!.name}]';

    final privateAllowed = _destination == null ||
        PlanGenerator.privateVehicleApplicable(_destination!, _origin);

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/login_page/logo/logo_omnitrip.png',
          height: 80,
          fit: BoxFit.contain,
        ),
        actions: [
          const FaqButton(screenKey: 'planner'),
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Booked Trips',
            icon: const Icon(HugeIcons.strokeRoundedBookmark02),
            onPressed: () => Navigator.pushNamed(context, '/booked'),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(HugeIcons.strokeRoundedLogout01),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _GreetingBanner(name: _firstName),
            const SizedBox(height: 6),
            Text(
              'Your trips with weather, traffic, and local insights. All in One Place.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            InputCard(
              icon: HugeIcons.strokeRoundedLocation01,
              label: 'Where to?',
              hint: 'e.g., Cebu City, Philippines',
              value: destLabel,
              onTap: _pickDestination,
            ),
            const SizedBox(height: 12),
            InputCard(
              icon: HugeIcons.strokeRoundedCalendar03,
              label: 'Travel Date',
              hint: 'Select your date',
              value: dateLabel,
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            _OriginPickerCard(
              origin: _origin,
              onTap: _pickOrigin,
            ),
            const SizedBox(height: 12),
            _TravelersStepper(
              count: _travelers,
              onChanged: (v) => setState(() => _travelers = v),
            ),
            const SizedBox(height: 12),
            _TransportSelector(
              mode: _transportMode,
              privateAllowed: privateAllowed,
              onChanged: (v) => setState(() => _transportMode = v),
            ),
            const SizedBox(height: 22),
            Text(
              purposeHeading,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: PurposeCard(
                    icon: HugeIcons.strokeRoundedBeach,
                    label: 'Vacation',
                    selected: _purpose == 'vacation',
                    onTap: () => setState(() => _purpose = 'vacation'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PurposeCard(
                    icon: HugeIcons.strokeRoundedFavourite,
                    label: 'Date Idea',
                    selected: _purpose == 'date_idea',
                    onTap: () => setState(() => _purpose = 'date_idea'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PurposeCard(
                    icon: HugeIcons.strokeRoundedBriefcase01,
                    label: 'School/\nBusiness',
                    selected: _purpose == 'school_business',
                    onTap: () =>
                        setState(() => _purpose = 'school_business'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Plan Options:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            ToggleRow(
              icon: HugeIcons.strokeRoundedCloud,
              title: 'Include Weather Forecast',
              value: _weatherAware,
              onChanged: (v) => setState(() => _weatherAware = v),
            ),
            const SizedBox(height: 4),
            ToggleRow(
              icon: HugeIcons.strokeRoundedCar01,
              title: 'Check Traffic & Routes',
              value: _trafficAware,
              onChanged: (v) => setState(() => _trafficAware = v),
            ),
            const SizedBox(height: 28),
            PillButton(
              label: 'Generate Smart Plan',
              onPressed: _generate,
              icon: HugeIcons.strokeRoundedSparkles,
            ),
          ],
        ),
      ),
    );
  }
}

class _OriginPickerCard extends StatelessWidget {
  final Origin? origin;
  final VoidCallback onTap;
  const _OriginPickerCard({required this.origin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final value = origin == null
        ? null
        : '${origin!.name}, ${origin!.province}';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.tealMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                HugeIcons.strokeRoundedRoute02,
                size: 18,
                color: AppColors.tealDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coming from',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? 'Select your starting city or province',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: value == null
                          ? AppColors.textSubtle
                          : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              HugeIcons.strokeRoundedArrowDown01,
              color: AppColors.textSubtle,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}


class _TravelersStepper extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const _TravelersStepper({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tealMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              HugeIcons.strokeRoundedUserMultiple,
              size: 18,
              color: AppColors.tealDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travelers',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  'How many are going?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.remove,
            enabled: count > 1,
            onTap: () => onChanged(count - 1),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
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
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppColors.tealPrimary : AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _TransportSelector extends StatelessWidget {
  final String mode;
  final bool privateAllowed;
  final ValueChanged<String> onChanged;

  const _TransportSelector({
    required this.mode,
    required this.privateAllowed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.tealMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  HugeIcons.strokeRoundedBus01,
                  size: 18,
                  color: AppColors.tealDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Transport Mode',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TransportOption(
                  label: 'Public Commute',
                  icon: HugeIcons.strokeRoundedBus01,
                  selected: mode == 'commute',
                  enabled: true,
                  onTap: () => onChanged('commute'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TransportOption(
                  label: 'Private Vehicle',
                  icon: HugeIcons.strokeRoundedCar01,
                  selected: mode == 'private',
                  enabled: privateAllowed,
                  onTap: () => onChanged('private'),
                ),
              ),
            ],
          ),
          if (!privateAllowed)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Private vehicle isn\'t practical here — fly or ferry only.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
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
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.tealSoft : AppColors.cardWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.tealPrimary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.tealDark : AppColors.tealPrimary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.tealDark : AppColors.textDark,
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

class _GreetingBanner extends StatefulWidget {
  final String? name;
  const _GreetingBanner({required this.name});

  @override
  State<_GreetingBanner> createState() => _GreetingBannerState();
}

class _GreetingBannerState extends State<_GreetingBanner> {
  static const _templates = <String>[
    'Saan Tayo Punta, {name}?',
    'Oh {name}, i-set na yan!',
    'Deserve mo gumala {name}!',
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
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Text(
        text,
        key: ValueKey<int>(_idx),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          height: 1.2,
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
                  Expanded(
                    child: Text(
                      'Choose Destination',
                      style: TextStyle(
                        fontSize: 18,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(HugeIcons.strokeRoundedSearch01),
                  hintText: 'Search city, province, region…',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _RegionPill(
                      label: 'All',
                      selected: _regionFilter == null,
                      onTap: () => setState(() => _regionFilter = null),
                    ),
                    const SizedBox(width: 6),
                    for (final region in Destinations.regions) ...[
                      _RegionPill(
                        label: region,
                        selected: _regionFilter == region,
                        onTap: () => setState(() => _regionFilter = region),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  for (final region in Destinations.regions)
                    if (byRegion[region]?.isNotEmpty ?? false) ...[
                      if (_regionFilter == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 6),
                          child: Text(
                            region.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tealDark,
                              letterSpacing: 1.1,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 6),
                      ...byRegion[region]!.map(
                        (d) => InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context, d),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Text(d.emoji, style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        d.province,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(HugeIcons.strokeRoundedArrowRight01,
                                    color: AppColors.textSubtle),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  if (filtered.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No destinations match your search.',
                          style: TextStyle(color: AppColors.textMuted),
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
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.tealPrimary : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.tealPrimary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
