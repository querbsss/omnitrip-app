import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../data/models/activity.dart';
import '../data/models/booked_trip.dart';
import '../data/models/travel_plan.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/faq_button.dart';
import 'widgets/pill_button.dart';
import 'widgets/section_header.dart';
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
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.ctaGlow,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Symbols.check_circle_rounded,
                    size: 38,
                    color: AppColors.brandDeep,
                    fill: 1,
                  ),
                ),
                const SizedBox(height: 18),
                Text('Trip Saved!', style: AppType.headlineLg),
                const SizedBox(height: 4),
                Text(
                  trip.title,
                  textAlign: TextAlign.center,
                  style: AppType.labelMd.copyWith(color: AppColors.brandDeep),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      _BreakdownRow(
                        icon: Symbols.location_on_rounded,
                        label: 'Destination',
                        value:
                            '${plan.destination.name}, ${plan.destination.region}',
                      ),
                      _BreakdownRow(
                        icon: Symbols.calendar_today_rounded,
                        label: 'Travel Date',
                        value: dateLabel,
                      ),
                      _BreakdownRow(
                        icon: Symbols.label_rounded,
                        label: 'Purpose',
                        value: BookedTrip.purposeLabel(plan.purpose),
                      ),
                      if (plan.weatherAware)
                        _BreakdownRow(
                          icon: Symbols.sunny_rounded,
                          label: 'Weather',
                          value: '${plan.forecast.season} • $lows°–$highs°C',
                        ),
                      if (plan.trafficAware)
                        _BreakdownRow(
                          icon: Symbols.directions_car_rounded,
                          label: 'Route',
                          value:
                              '${plan.routeInfo.transportMode} • ${plan.routeInfo.estimatedTravel}',
                        ),
                      _BreakdownRow(
                        icon: Symbols.auto_awesome_rounded,
                        label: 'Activities',
                        value:
                            '${plan.activities.length} hand-picked for you',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '🎉  Congrats!',
                  style: AppType.titleLg.copyWith(color: AppColors.brandDeep),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can find your trips in the\nBooked Trips page.',
                  textAlign: TextAlign.center,
                  style: AppType.bodySm,
                ),
                const SizedBox(height: 22),
                PillButton(
                  label: 'View Booked Trips',
                  icon: Symbols.arrow_forward_rounded,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    'Stay here',
                    style: AppType.labelMd.copyWith(
                      color: AppColors.outline,
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
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // Top bar
            Row(
              children: [
                _PillIcon(
                  icon: Symbols.arrow_back_rounded,
                  onTap: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISCOVERY RESULTS',
                        style: AppType.labelSm.copyWith(
                          color: AppColors.outline,
                        ),
                      ),
                      Text(
                        plan.destination.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.titleLg,
                      ),
                    ],
                  ),
                ),
                FaqButton(screenKey: 'results', subtle: true),
              ],
            ),
            const SizedBox(height: 18),

            // Featured hero card (8/12 equivalent)
            _FeaturedCard(plan: plan, dateLabel: dateLabel),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatChip(
                    icon: Symbols.group_rounded,
                    label:
                        '${plan.travelers} ${plan.travelers == 1 ? "Traveler" : "Travelers"}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatChip(
                    icon: Symbols.label_rounded,
                    label: BookedTrip.purposeLabel(plan.purpose),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
            if (plan.weatherAware) ...[
              SectionHeader(
                title: 'Weather Forecast',
                subtitle: plan.forecast.season,
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (ctx, c) {
                  const spacing = 8.0;
                  final w = (c.maxWidth - (spacing * 4)) / 5;
                  return Row(
                    children: [
                      for (int i = 0; i < plan.forecast.days.length; i++) ...[
                        SizedBox(
                          width: w,
                          child: WeatherDayCard(
                            day: plan.forecast.days[i],
                            label: 'D${i + 1}',
                          ),
                        ),
                        if (i < plan.forecast.days.length - 1)
                          const SizedBox(width: spacing),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _AdvisoryBanner(
                icon: Symbols.info_rounded,
                text: plan.forecast.advisory,
              ),
              const SizedBox(height: 28),
            ],

            // Traffic & Route
            SectionHeader(
              title: 'Traffic & Route',
              subtitle: plan.routeInfo.transportMode,
            ),
            const SizedBox(height: 14),
            TrafficRouteCard(
              route: plan.routeInfo,
              onOpenMap: () => _openMap(context, plan),
            ),
            const SizedBox(height: 12),
            _RouteDetails(plan: plan),

            const SizedBox(height: 28),
            SectionHeader(title: 'Trip Details'),
            const SizedBox(height: 14),
            _TripDetailsCard(plan: plan),

            const SizedBox(height: 28),
            SectionHeader(
              title: 'Cost Estimate',
              subtitle: 'Philippine Peso (PHP)',
            ),
            const SizedBox(height: 14),
            _CostEstimateCard(plan: plan),

            const SizedBox(height: 28),
            SectionHeader(
              title: 'Activities',
              subtitle: 'Hand-picked for your trip',
            ),
            const SizedBox(height: 14),
            if (plan.activities.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No activities found for this combination.',
                  style: AppType.bodySm,
                ),
              )
            else
              _ActivityBento(activities: plan.activities),

            if (plan.packingTips.isNotEmpty) ...[
              const SizedBox(height: 28),
              SectionHeader(title: 'What to Pack'),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tip in plan.packingTips)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.check_rounded,
                            size: 14,
                            color: AppColors.brandPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tip,
                            style: AppType.labelMd.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],

            if (plan.insights.isNotEmpty) ...[
              const SizedBox(height: 28),
              SectionHeader(title: 'Did You Know?'),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.softWarm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < plan.insights.length; i++) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.brandPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(plan.insights[i], style: AppType.bodySm),
                          ),
                        ],
                      ),
                      if (i < plan.insights.length - 1)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),
            if (alreadySaved)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.check_circle_rounded,
                      size: 20,
                      color: AppColors.onSecondaryContainer,
                      fill: 1,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Saved to Booked Trips',
                      style: AppType.labelMd.copyWith(
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              )
            else
              PillButton(
                label: 'Save to Booked Trips',
                icon: Symbols.bookmark_add_rounded,
                onPressed: () => _saveTrip(plan),
              ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Symbols.refresh_rounded,
                  size: 16,
                  color: AppColors.brandDeep,
                ),
                label: Text(
                  'Plan Another Trip',
                  style: AppType.labelMd.copyWith(
                    color: AppColors.brandDeep,
                  ),
                ),
              ),
            ),
          ],
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

class _FeaturedCard extends StatelessWidget {
  final TravelPlan plan;
  final String dateLabel;

  const _FeaturedCard({required this.plan, required this.dateLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.brandDeep,
                      AppColors.brandPrimary,
                      AppColors.secondary,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -10,
              child: Opacity(
                opacity: 0.18,
                child: Text(
                  plan.destination.emoji,
                  style: const TextStyle(fontSize: 220),
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
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.star_rounded,
                      size: 16,
                      color: AppColors.brandPrimary,
                      fill: 1,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.${(plan.destination.name.length % 9) + 1}',
                      style: AppType.labelMd.copyWith(
                        color: AppColors.brandDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'CURATED',
                  style: AppType.labelSm.copyWith(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plan.destination.region.toUpperCase(),
                    style: AppType.labelSm.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plan.destination.name,
                    style: AppType.headlineXl.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Symbols.calendar_today_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: AppType.labelMd.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
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
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(999),
        boxShadow: AppColors.softWarm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.brandDeep, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.labelMd.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvisoryBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AdvisoryBanner({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.brandSoft.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.brandDeep),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppType.bodySm.copyWith(color: AppColors.brandDeep),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityBento extends StatelessWidget {
  final List<TravelActivity> activities;
  const _ActivityBento({required this.activities});

  @override
  Widget build(BuildContext context) {
    final featured = activities.first;
    final supporting = activities.skip(1).take(4).toList();
    return Column(
      children: [
        _ActivityFeaturedCard(activity: featured),
        if (supporting.isNotEmpty) ...[
          const SizedBox(height: 12),
          _BentoPair(
            left: supporting[0],
            right: supporting.length > 1 ? supporting[1] : supporting[0],
          ),
          if (supporting.length > 2) ...[
            const SizedBox(height: 12),
            _BentoPair(
              left: supporting[2],
              right: supporting.length > 3 ? supporting[3] : supporting[2],
            ),
          ],
        ],
      ],
    );
  }
}

class _ActivityFeaturedCard extends StatelessWidget {
  final TravelActivity activity;
  const _ActivityFeaturedCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
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
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: Opacity(
                opacity: 0.3,
                child: Text(
                  activity.emoji,
                  style: const TextStyle(fontSize: 200),
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
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'TOP PICK',
                  style: AppType.labelSm.copyWith(color: AppColors.brandDeep),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.headlineLg.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Symbols.schedule_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        activity.duration,
                        style: AppType.labelMd.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
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
    );
  }
}

class _BentoPair extends StatelessWidget {
  final TravelActivity left;
  final TravelActivity right;

  const _BentoPair({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SmallActivityCard(activity: left)),
        const SizedBox(width: 12),
        Expanded(child: _SmallActivityCard(activity: right)),
      ],
    );
  }
}

class _SmallActivityCard extends StatelessWidget {
  final TravelActivity activity;
  const _SmallActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softWarm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              activity.emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            activity.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppType.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Symbols.schedule_rounded,
                size: 12,
                color: AppColors.outline,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  activity.duration,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.labelMd.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Save to Booked Trips', style: AppType.headlineLg),
                  const SizedBox(height: 6),
                  Text(
                    'You\'ll be able to view, edit, or remove it from\n'
                    'the Booked Trips page.',
                    style: AppType.bodySm,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: 'Trip Title',
                      prefixIcon: Icon(
                        Symbols.label_rounded,
                        color: AppColors.outline,
                      ),
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
                  const SizedBox(height: 24),
                  PillButton(
                    label: 'Save Trip',
                    icon: Symbols.bookmark_add_rounded,
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
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.brandDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppType.labelSm.copyWith(color: AppColors.outline),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppType.bodySm.copyWith(
                    color: AppColors.onSurface,
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

class _TripDetailsCard extends StatelessWidget {
  final TravelPlan plan;
  const _TripDetailsCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final transportLabel = BookedTrip.transportLabel(plan.transportMode);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softWarm,
      ),
      child: Column(
        children: [
          _BreakdownRow(
            icon: Symbols.route_rounded,
            label: 'Coming from',
            value: plan.originLocation.isEmpty ? '—' : plan.originLocation,
          ),
          _BreakdownRow(
            icon: Symbols.group_rounded,
            label: 'Travelers',
            value:
                '${plan.travelers} ${plan.travelers == 1 ? "person" : "people"}',
          ),
          _BreakdownRow(
            icon: plan.transportMode == 'private'
                ? Symbols.directions_car_rounded
                : Symbols.directions_bus_rounded,
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
      padding: const EdgeInsets.all(20),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _splitView ? 'PER PERSON' : 'TOTAL TRIP',
                      style: AppType.labelSm.copyWith(
                        color: AppColors.brandDeep,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      fmt.format(showAmount),
                      style: AppType.headlineXl.copyWith(
                        color: AppColors.brandDeep,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _splitView
                          ? 'Split among ${cost.travelers}'
                          : 'For ${cost.travelers} ${cost.travelers == 1 ? "person" : "people"}',
                      style: AppType.bodySm,
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
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                for (int i = 0; i < cost.items.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cost.items[i].label,
                          style: AppType.bodySm.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        fmt.format(_splitView
                            ? cost.items[i].amount / cost.travelers
                            : cost.items[i].amount),
                        style: AppType.labelMd.copyWith(
                          color: AppColors.onSurface,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  if (i < cost.items.length - 1) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.brandSoft.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.info_rounded,
                  size: 14,
                  color: AppColors.brandDeep,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _splitView
                        ? 'Each traveler chips in around ${fmt.format(cost.perPerson)}.'
                        : 'Estimate is rough — actual costs vary by season.',
                    style: AppType.labelMd.copyWith(
                      color: AppColors.brandDeep,
                      letterSpacing: 0,
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(999),
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
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected ? AppColors.ctaGlow : null,
        ),
        child: Text(
          label,
          style: AppType.labelMd.copyWith(
            color: selected ? AppColors.onBrand : AppColors.onSurfaceVariant,
            letterSpacing: 0,
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
              Icon(
                Symbols.directions_bus_rounded,
                size: 18,
                color: AppColors.brandDeep,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${r.fromHub}  →  ${r.toDestination}',
                  style: AppType.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${r.transportMode} • ${r.estimatedTravel}',
            style: AppType.bodySm,
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < r.steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: AppColors.onBrand,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(r.steps[i], style: AppType.bodySm),
                  ),
                ),
              ],
            ),
            if (i < r.steps.length - 1) const SizedBox(height: 10),
          ],
          if (plan.trafficAware) ...[
            const SizedBox(height: 14),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.warnBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.warning_rounded,
                    size: 16,
                    color: AppColors.warnIcon,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.trafficAdvisory,
                      style: AppType.labelMd.copyWith(
                        color: AppColors.warnText,
                        letterSpacing: 0,
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
