import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/colors.dart';
import '../../data/datasets/origins.dart';
import '../../data/models/origin.dart';

class OriginPickerSheet extends StatefulWidget {
  const OriginPickerSheet({super.key});

  @override
  State<OriginPickerSheet> createState() => _OriginPickerSheetState();
}

class _OriginPickerSheetState extends State<OriginPickerSheet> {
  String _query = '';
  String? _islandFilter;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    final filtered = Origins.all.where((o) {
      if (_islandFilter != null && o.island != _islandFilter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return o.name.toLowerCase().contains(q) ||
          o.province.toLowerCase().contains(q) ||
          o.island.toLowerCase().contains(q);
    }).toList();

    final byIsland = <String, List<Origin>>{};
    for (final o in filtered) {
      byIsland.putIfAbsent(o.island, () => []).add(o);
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
                      'Where are you coming from?',
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
                  hintText: 'Search city or province…',
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
                    _IslandPill(
                      label: 'All',
                      selected: _islandFilter == null,
                      onTap: () => setState(() => _islandFilter = null),
                    ),
                    const SizedBox(width: 6),
                    for (final island in Origins.islands) ...[
                      _IslandPill(
                        label: island,
                        selected: _islandFilter == island,
                        onTap: () => setState(() => _islandFilter = island),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  for (final island in Origins.islands)
                    if (byIsland[island]?.isNotEmpty ?? false) ...[
                      if (_islandFilter == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 6),
                          child: Text(
                            island.toUpperCase(),
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
                      ...byIsland[island]!.map(
                        (o) => InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context, o),
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
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.tealMuted,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    HugeIcons.strokeRoundedLocation01,
                                    size: 16,
                                    color: AppColors.tealDark,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        o.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        o.province,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  HugeIcons.strokeRoundedArrowRight01,
                                  color: AppColors.textSubtle,
                                ),
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
                          'No matches found.',
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

class _IslandPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _IslandPill({
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
