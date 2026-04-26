import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../data/datasets/destinations.dart';
import '../data/models/booked_trip.dart';
import '../data/models/destination.dart';
import '../data/services/booked_trips_service.dart';
import '../data/services/plan_generator.dart';
import '../data/services/session_service.dart';
import 'results_args.dart';
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
      backgroundColor: AppColors.bgCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TripEditSheet(trip: trip),
    );
    if (updated == null) return;
    await _service.update(updated);
    await _refresh();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.tealDark,
        behavior: SnackBarBehavior.floating,
        content: Text('Trip updated.'),
      ),
    );
  }

  Future<void> _deleteTrip(BookedTrip trip) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Remove this trip?'),
        content: Text(
          '"${trip.title}" will be removed from your Booked Trips.',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.tealDark,
        behavior: SnackBarBehavior.floating,
        content: Text('Trip removed.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Image.asset(
          'assets/images/login_page/logo/logo_omnitrip.png',
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.tealPrimary,
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booked Trips',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _trips.isEmpty
                          ? 'You haven\'t saved any trips yet.'
                          : '${_trips.length} saved trip${_trips.length == 1 ? '' : 's'} — tap one to view, edit, or remove.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _trips.isEmpty
                          ? const _EmptyState()
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: AppColors.tealPrimary,
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _trips.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
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
                        icon: HugeIcons.strokeRoundedSparkles,
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/planner',
                          (_) => false,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.tealMuted,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.luggage_outlined,
              size: 38,
              color: AppColors.tealDark,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No saved trips yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Generate a plan from the Planner and tap "Save Trip"\nto see it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.tealMuted,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    destination.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${destination.name}, ${destination.region}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _MenuButton(
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Chip(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  label: dateLabel,
                ),
                const SizedBox(width: 6),
                _Chip(
                  icon: HugeIcons.strokeRoundedTag01,
                  label: BookedTrip.purposeLabel(trip.purpose),
                ),
              ],
            ),
            if (trip.notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgCream,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  trip.notes,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
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
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.tealMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.tealDark),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
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

class _MenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuButton({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Trip options',
      icon: const Icon(
        HugeIcons.strokeRoundedMoreVertical,
        color: AppColors.textMuted,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: AppColors.cardWhite,
      onSelected: (v) {
        if (v == 'edit') onEdit();
        if (v == 'delete') onDelete();
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(HugeIcons.strokeRoundedEdit02,
                  size: 16, color: AppColors.tealDark),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(HugeIcons.strokeRoundedDelete02,
                  size: 16, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Remove'),
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
  late DateTime _date;
  late String _purpose;
  late bool _weather;
  late bool _traffic;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.trip.title);
    _notesCtrl = TextEditingController(text: widget.trip.notes);
    _date = widget.trip.travelDate;
    _purpose = widget.trip.purpose;
    _weather = widget.trip.weatherAware;
    _traffic = widget.trip.trafficAware;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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

  void _save() {
    final updated = widget.trip.copyWith(
      title: _titleCtrl.text,
      travelDate: _date,
      purpose: _purpose,
      weatherAware: _weather,
      trafficAware: _traffic,
      notes: _notesCtrl.text,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

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
                      'Edit Trip',
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
            Flexible(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Trip Title',
                      hintText: 'e.g., Summer in Cebu',
                      prefixIcon: Icon(HugeIcons.strokeRoundedTag01),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Travel Date',
                        prefixIcon: Icon(HugeIcons.strokeRoundedCalendar03),
                      ),
                      child: Text(
                        DateFormat('EEE, MMM d, y').format(_date),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Travel Purpose',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _purposeChoice('vacation', 'Vacation',
                          HugeIcons.strokeRoundedBeach),
                      _purposeChoice('date_idea', 'Date Idea',
                          HugeIcons.strokeRoundedFavourite),
                      _purposeChoice('school_business', 'School / Business',
                          HugeIcons.strokeRoundedBriefcase01),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Include Weather Forecast',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _weather,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.tealPrimary,
                    onChanged: (v) => setState(() => _weather = v),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Check Traffic & Routes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _traffic,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.tealPrimary,
                    onChanged: (v) => setState(() => _traffic = v),
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 22),
                  PillButton(
                    label: 'Save Changes',
                    icon: HugeIcons.strokeRoundedTick02,
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

  Widget _purposeChoice(String value, String label, IconData icon) {
    final selected = _purpose == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _purpose = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.tealSoft : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.tealPrimary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: selected ? AppColors.tealDark : AppColors.tealPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.tealDark : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
