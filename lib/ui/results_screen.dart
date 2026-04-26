import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/colors.dart';
import '../data/models/booked_trip.dart';
import '../data/models/travel_plan.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/faq_button.dart';
import 'widgets/insight_card.dart';
import 'widgets/pill_button.dart';
import 'widgets/theme_toggle_button.dart';
import 'widgets/traffic_route_card.dart';
import 'widgets/weather_day_card.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String? _savedTripId;

  Future<void> _openMap(BuildContext context, TravelPlan plan) async {
    final url = Uri.parse(plan.destination.mapLink);
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  Future<void> _saveTrip(TravelPlan plan) async {
    final email = await SessionService().getSessionEmail();
    if (email == null || !mounted) return;

    final result = await showModalBottomSheet<_SaveTripResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SaveTripSheet(plan: plan),
    );
    if (result == null || !mounted) return;

    final trip = await BookedTripsService().add(
      email: email,
      title: result.title,
      destinationId: plan.destination.id,
      travelDate: plan.travelDate,
      purpose: plan.purpose,
      weatherAware: plan.weatherAware,
      trafficAware: plan.trafficAware,
      notes: result.notes,
      originLocation: plan.originLocation,
      travelers: plan.travelers,
      transportMode: plan.transportMode,
    );
    if (!mounted) return;
    setState(() => _savedTripId = trip.id);
    await _showCongratsDialog(plan, trip);
  }

  Future<void> _showCongratsDialog(TravelPlan plan, BookedTrip trip) async {
    final dateLabel = DateFormat('EEE, MMM d, y').format(plan.travelDate);
    final highs = plan.forecast.days
        .map((d) => d.highC)
        .reduce((a, b) => a > b ? a : b);
    final lows = plan.forecast.days
        .map((d) => d.lowC)
        .reduce((a, b) => a < b ? a : b);
    final goToBooked = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.tealMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    HugeIcons.strokeRoundedCheckmarkCircle02,
                    size: 36,
                    color: AppColors.tealDark,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Trip Saved!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trip.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.tealDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _BreakdownRow(
                        icon: HugeIcons.strokeRoundedLocation01,
                        label: 'Destination',
                        value:
                            '${plan.destination.name}, ${plan.destination.region}',
                      ),
                      _BreakdownRow(
                        icon: HugeIcons.strokeRoundedCalendar03,
                        label: 'Travel Date',
                        value: dateLabel,
                      ),
                      _BreakdownRow(
                        icon: HugeIcons.strokeRoundedTag01,
                        label: 'Purpose',
                        value: BookedTrip.purposeLabel(plan.purpose),
                      ),
                      if (plan.weatherAware)
                        _BreakdownRow(
                          icon: HugeIcons.strokeRoundedSun03,
                          label: 'Weather',
                          value:
                              '${plan.forecast.season} • $lows°–$highs°C',
                        ),
                      if (plan.trafficAware)
                        _BreakdownRow(
                          icon: HugeIcons.strokeRoundedCar01,
                          label: 'Route',
                          value:
                              '${plan.routeInfo.transportMode} • ${plan.routeInfo.estimatedTravel}',
                        ),
                      _BreakdownRow(
                        icon: HugeIcons.strokeRoundedSparkles,
                        label: 'Activities',
                        value:
                            '${plan.activities.length} hand-picked for you',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '🎉  Congrats!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tealDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can find your trips in the\nBooked Trips page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                PillButton(
                  label: 'View Booked Trips',
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    'Stay here',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted) return;
    if (goToBooked == true) {
      Navigator.pushNamed(context, '/booked');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    late final TravelPlan plan;
    if (args is ResultsArgs) {
      plan = args.plan;
      _savedTripId ??= args.savedTripId;
    } else {
      plan = args as TravelPlan;
    }
    final dateLabel = DateFormat('MMM d, y').format(plan.travelDate);
    final alreadySaved = _savedTripId != null;

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        toolbarHeight: 160,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Transform.translate(
          offset: const Offset(-3, 0),
          child: Image.asset(
            'assets/images/login_page/logo/logo_omnitrip.png',
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
        actions: const [
          FaqButton(screenKey: 'results'),
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // ── Hero header ──────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 14,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.tealMuted,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      plan.destination.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Smart Plan:',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${plan.destination.name}, Philippines',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(HugeIcons.strokeRoundedCalendar03,
                                size: 12, color: AppColors.tealDark),
                            const SizedBox(width: 4),
                            Text(
                              dateLabel,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.tealDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),
            // ── Weather Forecast ─────────────
            if (plan.weatherAware) ...[
              const _SectionTitle('Weather Forecast'),
              const SizedBox(height: 10),
              LayoutBuilder(builder: (ctx, c) {
                final spacing = 8.0;
                final w = (c.maxWidth - (spacing * 4)) / 5;
                return Row(
                  children: [
                    for (int i = 0; i < plan.forecast.days.length; i++) ...[
                      SizedBox(
                        width: w,
                        child: WeatherDayCard(
                          day: plan.forecast.days[i],
                          label: '${i + 1}-day',
                        ),
                      ),
                      if (i < plan.forecast.days.length - 1)
                        SizedBox(width: spacing),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.tealMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedInformationCircle,
                        size: 16, color: AppColors.tealDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        plan.forecast.advisory,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.tealDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],

            // ── Traffic & Route ──────────────
            const _SectionTitle('Traffic & Route'),
            const SizedBox(height: 10),
            TrafficRouteCard(
              route: plan.routeInfo,
              onOpenMap: () => _openMap(context, plan),
            ),
            const SizedBox(height: 8),
            _RouteDetails(plan: plan),
            const SizedBox(height: 22),

            // ── Trip Details (origin / travelers / transport) ──
            const _SectionTitle('Trip Details'),
            const SizedBox(height: 10),
            _TripDetailsCard(plan: plan),
            const SizedBox(height: 22),

            // ── Cost Estimate ────────────────
            const _SectionTitle('Cost Estimate (PHP)'),
            const SizedBox(height: 10),
            _CostEstimateCard(plan: plan),
            const SizedBox(height: 22),

            // ── Insights & Activities ────────
            const _SectionTitle('Destination Insights & Activities'),
            const SizedBox(height: 10),
            if (plan.activities.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No activities found for this combination.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: plan.activities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (ctx, i) => InsightCard(
                    activity: plan.activities[i],
                    width: 150,
                  ),
                ),
              ),
            const SizedBox(height: 18),

            // ── Packing tips ─────────────────
            if (plan.packingTips.isNotEmpty) ...[
              const _SectionTitle('What to Pack'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tip in plan.packingTips)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(HugeIcons.strokeRoundedTick02,
                              size: 14, color: AppColors.tealPrimary),
                          const SizedBox(width: 6),
                          Text(
                            tip,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
            ],

            // ── Quick insights ───────────────
            if (plan.insights.isNotEmpty) ...[
              const _SectionTitle('Did You Know?'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final i in plan.insights) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle,
                                size: 6, color: AppColors.tealPrimary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              i,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Save trip ────────────────────
            if (alreadySaved)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.tealMuted,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedCheckmarkCircle02,
                        size: 18, color: AppColors.tealDark),
                    SizedBox(width: 8),
                    Text(
                      'Saved to Booked Trips',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tealDark,
                      ),
                    ),
                  ],
                ),
              )
            else
              PillButton(
                label: 'Save to Booked Trips',
                icon: HugeIcons.strokeRoundedBookmarkAdd01,
                onPressed: () => _saveTrip(plan),
              ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(HugeIcons.strokeRoundedRefresh,
                  size: 16, color: AppColors.tealDark),
              label: Text(
                'Plan Another Trip',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tealDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveTripResult {
  final String title;
  final String notes;
  const _SaveTripResult(this.title, this.notes);
}

class _SaveTripSheet extends StatefulWidget {
  final TravelPlan plan;
  const _SaveTripSheet({required this.plan});

  @override
  State<_SaveTripSheet> createState() => _SaveTripSheetState();
}

class _SaveTripSheetState extends State<_SaveTripSheet> {
  late TextEditingController _title;
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text: 'Trip to ${widget.plan.destination.name}',
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: SingleChildScrollView(
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Save to Booked Trips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You\'ll be able to view, edit, or remove it from\nthe Booked Trips page.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'Trip Title',
                      prefixIcon: Icon(HugeIcons.strokeRoundedTag01),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notes,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Reminders, who you\'re going with, budget…',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 22),
                  PillButton(
                    label: 'Save Trip',
                    icon: HugeIcons.strokeRoundedBookmarkAdd01,
                    onPressed: () => Navigator.pop(
                      context,
                      _SaveTripResult(_title.text, _notes.text),
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

class _BreakdownRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _BreakdownRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.tealDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
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

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _TripDetailsCard extends StatelessWidget {
  final TravelPlan plan;
  const _TripDetailsCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final transportLabel = BookedTrip.transportLabel(plan.transportMode);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _BreakdownRow(
            icon: HugeIcons.strokeRoundedRoute02,
            label: 'Coming from',
            value: plan.originLocation.isEmpty ? '—' : plan.originLocation,
          ),
          _BreakdownRow(
            icon: HugeIcons.strokeRoundedUserMultiple,
            label: 'Travelers',
            value: '${plan.travelers} ${plan.travelers == 1 ? "person" : "people"}',
          ),
          _BreakdownRow(
            icon: plan.transportMode == 'private'
                ? HugeIcons.strokeRoundedCar01
                : HugeIcons.strokeRoundedBus01,
            label: 'Transport',
            value: transportLabel,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _CostEstimateCard extends StatefulWidget {
  final TravelPlan plan;
  const _CostEstimateCard({required this.plan});

  @override
  State<_CostEstimateCard> createState() => _CostEstimateCardState();
}

class _CostEstimateCardState extends State<_CostEstimateCard> {
  bool _splitView = false;

  @override
  Widget build(BuildContext context) {
    final cost = widget.plan.costEstimate;
    final fmt = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );
    final showAmount = _splitView ? cost.perPerson : cost.total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _splitView ? 'Per Person' : 'Total Trip',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fmt.format(showAmount),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tealDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _splitView
                          ? 'Split among ${cost.travelers} ${cost.travelers == 1 ? "person" : "people"}'
                          : 'For ${cost.travelers} ${cost.travelers == 1 ? "person" : "people"}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _SplitToggle(
                splitView: _splitView,
                onChanged: (v) => setState(() => _splitView = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          for (final item in cost.items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  fmt.format(_splitView
                      ? item.amount / cost.travelers
                      : item.amount),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.tealMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedInformationCircle,
                  size: 14,
                  color: AppColors.tealDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _splitView
                        ? 'Each traveler chips in around ${fmt.format(cost.perPerson)}.'
                        : 'Estimate is rough — actual costs vary by season and choices.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.tealDark,
                      height: 1.4,
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

class _SplitToggle extends StatelessWidget {
  final bool splitView;
  final ValueChanged<bool> onChanged;

  const _SplitToggle({required this.splitView, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SplitToggleChip(
            label: 'Total',
            selected: !splitView,
            onTap: () => onChanged(false),
          ),
          _SplitToggleChip(
            label: 'Split',
            selected: splitView,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _SplitToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SplitToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.tealPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _RouteDetails extends StatelessWidget {
  final TravelPlan plan;
  const _RouteDetails({required this.plan});

  @override
  Widget build(BuildContext context) {
    final r = plan.routeInfo;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(HugeIcons.strokeRoundedBus01,
                  size: 16, color: AppColors.tealDark),
              const SizedBox(width: 6),
              Text(
                '${r.fromHub}  →  ${r.toDestination}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${r.transportMode} • ${r.estimatedTravel}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < r.steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.tealPrimary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    r.steps[i],
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i < r.steps.length - 1) const SizedBox(height: 6),
          ],
          if (plan.trafficAware) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(HugeIcons.strokeRoundedAlert02,
                      size: 14, color: Color(0xFFD97706)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      r.trafficAdvisory,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF92400E),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
