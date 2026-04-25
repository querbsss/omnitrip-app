import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/colors.dart';
import '../data/models/travel_plan.dart';
import 'widgets/insight_card.dart';
import 'widgets/pill_button.dart';
import 'widgets/traffic_route_card.dart';
import 'widgets/weather_day_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Future<void> _openMap(BuildContext context, TravelPlan plan) async {
    final url = Uri.parse(plan.destination.mapLink);
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = ModalRoute.of(context)!.settings.arguments as TravelPlan;
    final dateLabel = DateFormat('MMM d, y').format(plan.travelDate);

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
                boxShadow: const [
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
                        const Text(
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(HugeIcons.strokeRoundedCalendar03,
                                size: 12, color: AppColors.tealDark),
                            const SizedBox(width: 4),
                            Text(
                              dateLabel,
                              style: const TextStyle(
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
                    const Icon(HugeIcons.strokeRoundedInformationCircle,
                        size: 16, color: AppColors.tealDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        plan.forecast.advisory,
                        style: const TextStyle(
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

            // ── Insights & Activities ────────
            const _SectionTitle('Destination Insights & Activities'),
            const SizedBox(height: 10),
            if (plan.activities.isEmpty)
              const Padding(
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
                          const Icon(HugeIcons.strokeRoundedTick02,
                              size: 14, color: AppColors.tealPrimary),
                          const SizedBox(width: 6),
                          Text(
                            tip,
                            style: const TextStyle(
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
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle,
                                size: 6, color: AppColors.tealPrimary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              i,
                              style: const TextStyle(
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

            PillButton(
              label: 'Plan Another Trip',
              icon: HugeIcons.strokeRoundedRefresh,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
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
              const Icon(HugeIcons.strokeRoundedBus01,
                  size: 16, color: AppColors.tealDark),
              const SizedBox(width: 6),
              Text(
                '${r.fromHub}  →  ${r.toDestination}',
                style: const TextStyle(
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
            style: const TextStyle(
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
                    style: const TextStyle(
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
