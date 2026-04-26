import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../data/datasets/destinations.dart';
import '../data/models/destination.dart';
import '../data/services/auth_service.dart';
import '../data/services/plan_generator.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/input_card.dart';
import 'widgets/pill_button.dart';
import 'widgets/purpose_card.dart';
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
      setState(() => _destination = selected);
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
          colorScheme: const ColorScheme.light(
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
    final plan = PlanGenerator().generate(
      destination: _destination!,
      travelDate: _date!,
      purpose: _purpose!,
      weatherAware: _weatherAware,
      trafficAware: _trafficAware,
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
            const Text(
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
            const SizedBox(height: 22),
            Text(
              purposeHeading,
              style: const TextStyle(
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
            const Text(
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
        style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    final filtered = Destinations.all.where((d) {
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
                  const Expanded(
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
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  for (final region in Destinations.regions)
                    if (byRegion[region]?.isNotEmpty ?? false) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: Text(
                          region.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tealDark,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
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
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        d.province,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(HugeIcons.strokeRoundedArrowRight01,
                                    color: AppColors.textSubtle),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  if (filtered.isEmpty)
                    const Padding(
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
