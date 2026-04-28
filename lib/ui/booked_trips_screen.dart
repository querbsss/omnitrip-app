import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../data/datasets/destinations.dart';
import '../data/datasets/origins.dart';
import '../data/models/booked_trip.dart';
import '../data/models/destination.dart';
import '../data/models/origin.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/plan_generator.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
import 'widgets/bottom_nav_pill.dart';
import 'widgets/origin_picker_sheet.dart';
import 'widgets/pill_button.dart';

class BookedTripsScreen extends StatefulWidget {
  const BookedTripsScreen({super.key});

  @override
  State<BookedTripsScreen> createState() => _BookedTripsScreenState();
}

class _BookedTripsScreenState extends State<BookedTripsScreen> {
  final _service = BookedTripsService();
  String? _email;
  List<BookedTrip> _trips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final email = await SessionService().getSessionEmail();
    if (!mounted) return;
    if (email == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      return;
    }
    final trips = await _service.all(email);
    if (!mounted) return;
    setState(() {
      _email = email;
      _trips = trips;
      _loading = false;
    });
  }

  void _viewTrip(BookedTrip trip) {
    final dest = Destinations.byId(trip.destinationId);
    final plan = PlanGenerator().generate(
      destination: dest,
      travelDate: trip.travelDate,
      purpose: trip.purpose,
      weatherAware: trip.weatherAware,
      trafficAware: trip.trafficAware,
      originLocation: trip.originLocation,
      travelers: trip.travelers,
      transportMode: trip.transportMode,
    );
    Navigator.pushNamed(
      context,
      '/results',
      arguments: ResultsArgs(plan, savedTripId: trip.id),
    ).then((_) => _refresh());
  }

  Future<void> _editTrip(BookedTrip trip) async {
    final updated = await showModalBottomSheet<BookedTrip>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => _TripEditSheet(trip: trip),
    );
    if (updated == null) return;
    await _service.update(updated);
    await _refresh();
    if (!mounted) return;
    _toast('Trip updated.');
  }

  Future<void> _deleteTrip(BookedTrip trip) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text('Remove this trip?', style: AppType.titleLg),
        content: Text(
          '"${trip.title}" will be removed from your Booked Trips.',
          style: AppType.bodySm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: AppType.labelMd.copyWith(color: AppColors.outline),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Remove',
              style: AppType.labelMd.copyWith(
                color: const Color(0xFFBA1A1A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || _email == null) return;
    await _service.remove(email: _email!, id: trip.id);
    await _refresh();
    if (!mounted) return;
    _toast('Trip removed.');
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
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                    'BOOKED',
                                    style: AppType.labelSm.copyWith(
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  Text('Your Trips', style: AppType.headlineLg),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 56),
                          child: Text(
                            _trips.isEmpty
                                ? 'You haven\'t saved any trips yet.'
                                : '${_trips.length} saved trip${_trips.length == 1 ? '' : 's'} — tap any to view.',
                            style: AppType.bodySm,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: _trips.isEmpty
                              ? const _EmptyState()
                              : RefreshIndicator(
                                  onRefresh: _refresh,
                                  color: AppColors.brandPrimary,
                                  child: ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 110),
                                    itemCount: _trips.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 14),
                                    itemBuilder: (ctx, i) {
                                      final t = _trips[i];
                                      return _TripCard(
                                        trip: t,
                                        destination:
                                            Destinations.byId(t.destinationId),
                                        onTap: () => _viewTrip(t),
                                        onEdit: () => _editTrip(t),
                                        onDelete: () => _deleteTrip(t),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        if (_trips.isEmpty) ...[
                          PillButton(
                            label: 'Plan a New Trip',
                            icon: Symbols.auto_awesome_rounded,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/planner'),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ],
                    ),
                  ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BottomNavPill(current: BottomNavTab.trips),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(28),
              boxShadow: AppColors.softWarm,
            ),
            child: Icon(
              Symbols.luggage_rounded,
              size: 44,
              color: AppColors.brandDeep,
            ),
          ),
          const SizedBox(height: 22),
          Text('No saved trips yet', style: AppType.headlineLg),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Generate a plan from the Planner and tap "Save Trip" '
              'to see it here.',
              textAlign: TextAlign.center,
              style: AppType.bodySm,
            ),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final BookedTrip trip;
  final Destination destination;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TripCard({
    required this.trip,
    required this.destination,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d, y').format(trip.travelDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tripDay = DateTime(
      trip.travelDate.year,
      trip.travelDate.month,
      trip.travelDate.day,
    );
    final daysLeft = tripDay.difference(today).inDays;
    final isPast = daysLeft < 0;
    return Opacity(
      opacity: isPast ? 0.6 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.brandFixedDim,
                          AppColors.brandPrimary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      destination.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.titleLg.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${destination.name}, ${destination.region}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.bodySm,
                        ),
                      ],
                    ),
                  ),
                  _MenuButton(onEdit: onEdit, onDelete: onDelete),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip(
                    icon: Symbols.calendar_today_rounded,
                    label: dateLabel,
                  ),
                  _Chip(
                    icon: Symbols.label_rounded,
                    label: BookedTrip.purposeLabel(trip.purpose),
                  ),
                  _CountdownChip(daysLeft: daysLeft),
                  if (trip.travelers > 1)
                    _Chip(
                      icon: Symbols.group_rounded,
                      label: '${trip.travelers} pax',
                    ),
                ],
              ),
              if (trip.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    trip.notes,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.bodySm.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownChip extends StatelessWidget {
  final int daysLeft;
  const _CountdownChip({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    String label;
    Color bg;
    Color fg;
    if (daysLeft < 0) {
      label = 'Past';
      bg = AppColors.surfaceContainer;
      fg = AppColors.onSurfaceVariant;
    } else if (daysLeft == 0) {
      label = 'Today!';
      bg = AppColors.warnBg;
      fg = AppColors.warnText;
    } else if (daysLeft == 1) {
      label = 'Tomorrow';
      bg = AppColors.warnBg;
      fg = AppColors.warnText;
    } else if (daysLeft <= 30) {
      label = 'In $daysLeft days';
      bg = AppColors.secondaryContainer;
      fg = AppColors.onSecondaryContainer;
    } else {
      final months = (daysLeft / 30).round();
      label = months == 1 ? 'In 1 month' : 'In $months months';
      bg = AppColors.secondaryContainer;
      fg = AppColors.onSecondaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.schedule_rounded, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(label, style: AppType.labelMd.copyWith(color: fg)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.brandDeep),
          const SizedBox(width: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.labelMd.copyWith(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuButton({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Trip options',
      icon: Icon(
        Symbols.more_vert_rounded,
        color: AppColors.outline,
        size: 22,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.surfaceCard,
      onSelected: (v) {
        if (v == 'edit') onEdit();
        if (v == 'delete') onDelete();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Symbols.edit_rounded,
                size: 18,
                color: AppColors.brandDeep,
              ),
              const SizedBox(width: 10),
              Text('Edit', style: AppType.bodySm.copyWith(color: AppColors.onSurface)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Symbols.delete_rounded,
                size: 18,
                color: const Color(0xFFBA1A1A),
              ),
              const SizedBox(width: 10),
              Text(
                'Remove',
                style: AppType.bodySm.copyWith(
                  color: const Color(0xFFBA1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripEditSheet extends StatefulWidget {
  final BookedTrip trip;
  const _TripEditSheet({required this.trip});

  @override
  State<_TripEditSheet> createState() => _TripEditSheetState();
}

class _TripEditSheetState extends State<_TripEditSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _notesCtrl;
  Origin? _origin;
  late DateTime _date;
  late String _purpose;
  late bool _weather;
  late bool _traffic;
  late int _travelers;
  late String _transportMode;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.trip.title);
    _notesCtrl = TextEditingController(text: widget.trip.notes);
    _origin = Origins.byName(widget.trip.originLocation);
    _date = widget.trip.travelDate;
    _purpose = widget.trip.purpose;
    _weather = widget.trip.weatherAware;
    _traffic = widget.trip.trafficAware;
    _travelers = widget.trip.travelers;
    _transportMode = widget.trip.transportMode;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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
    if (selected != null) setState(() => _origin = selected);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(now) ? now : _date,
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

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.brandDeep,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          content: Text(
            'Please enter a trip title.',
            style: TextStyle(color: AppColors.onBrand),
          ),
        ),
      );
      return;
    }
    final updated = widget.trip.copyWith(
      title: _titleCtrl.text,
      travelDate: _date,
      purpose: _purpose,
      weatherAware: _weather,
      trafficAware: _traffic,
      notes: _notesCtrl.text,
      originLocation: _origin?.name ?? widget.trip.originLocation,
      travelers: _travelers,
      transportMode: _transportMode,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;
    final dest = Destinations.byId(widget.trip.destinationId);
    final privateAllowed =
        PlanGenerator.privateVehicleApplicable(dest, _origin);
    if (!privateAllowed && _transportMode == 'private') {
      _transportMode = 'commute';
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
                    child: Text('Edit Trip', style: AppType.headlineLg),
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
            Flexible(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Trip Title',
                      hintText: 'e.g., Summer in Cebu',
                      prefixIcon: Icon(
                        Symbols.label_rounded,
                        color: AppColors.outline,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(999),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Travel Date',
                        prefixIcon: Icon(
                          Symbols.calendar_today_rounded,
                          color: AppColors.outline,
                        ),
                      ),
                      child: Text(
                        DateFormat('EEE, MMM d, y').format(_date),
                        style: AppType.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'TRAVEL PURPOSE',
                    style: AppType.labelSm.copyWith(color: AppColors.outline),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _purposeChoice(
                        'vacation',
                        'Vacation',
                        Symbols.beach_access_rounded,
                      ),
                      _purposeChoice(
                        'date_idea',
                        'Date Idea',
                        Symbols.favorite_rounded,
                      ),
                      _purposeChoice(
                        'school_business',
                        'School / Business',
                        Symbols.work_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: _pickOrigin,
                    borderRadius: BorderRadius.circular(999),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Coming from',
                        prefixIcon: Icon(
                          Symbols.route_rounded,
                          color: AppColors.outline,
                        ),
                        suffixIcon: Icon(
                          Symbols.expand_more_rounded,
                          color: AppColors.outline,
                        ),
                      ),
                      child: Text(
                        _origin == null
                            ? (widget.trip.originLocation.isEmpty
                                ? 'Select your starting city'
                                : '${widget.trip.originLocation} (tap to update)')
                            : '${_origin!.name}, ${_origin!.province}',
                        style: AppType.bodyMd.copyWith(
                          color: _origin == null
                              ? AppColors.outlineVariant
                              : AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Symbols.group_rounded,
                          size: 22,
                          color: AppColors.brandDeep,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Travelers',
                            style: AppType.bodyMd.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _StepBtn(
                          icon: Symbols.remove_rounded,
                          enabled: _travelers > 1,
                          onTap: () => setState(() => _travelers--),
                        ),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '$_travelers',
                            textAlign: TextAlign.center,
                            style: AppType.titleLg,
                          ),
                        ),
                        _StepBtn(
                          icon: Symbols.add_rounded,
                          enabled: _travelers < 20,
                          onTap: () => setState(() => _travelers++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'TRANSPORT',
                    style: AppType.labelSm.copyWith(color: AppColors.outline),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _transportChoice(
                        'commute',
                        'Public Commute',
                        Symbols.directions_bus_rounded,
                        true,
                      ),
                      _transportChoice(
                        'private',
                        'Private Vehicle',
                        Symbols.directions_car_rounded,
                        privateAllowed,
                      ),
                    ],
                  ),
                  if (!privateAllowed)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Private vehicle isn\'t practical for this destination.',
                        style: AppType.bodySm.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Include Weather Forecast',
                      style: AppType.bodyMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    value: _weather,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.brandPrimary,
                    onChanged: (v) => setState(() => _weather = v),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Check Traffic & Routes',
                      style: AppType.bodyMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    value: _traffic,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.brandPrimary,
                    onChanged: (v) => setState(() => _traffic = v),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    minLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Reminders, who you\'re going with, budget…',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PillButton(
                    label: 'Save Changes',
                    icon: Symbols.check_rounded,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transportChoice(
    String value,
    String label,
    IconData icon,
    bool enabled,
  ) {
    final selected = _transportMode == value;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: enabled ? () => setState(() => _transportMode = value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.secondaryContainer
                : AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppColors.onSecondaryContainer
                    : AppColors.brandDeep,
                fill: selected ? 1 : 0,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppType.labelMd.copyWith(
                  color: selected
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _purposeChoice(String value, String label, IconData icon) {
    final selected = _purpose == value;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _purpose = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryContainer
              : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? AppColors.onSecondaryContainer
                  : AppColors.brandDeep,
              fill: selected ? 1 : 0,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppType.labelMd.copyWith(
                color: selected
                    ? AppColors.onSecondaryContainer
                    : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepBtn({
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
