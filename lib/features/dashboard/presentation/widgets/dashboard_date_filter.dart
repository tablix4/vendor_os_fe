import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_date_range_picker.dart';
import '../providers/dashboard_provider.dart';

class DashboardDateFilterWidget extends ConsumerWidget {
  const DashboardDateFilterWidget({super.key});

  static const Color _green = Color(0xff16A34A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(dashboardFilterProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showFilterBottomSheet(context, ref, filterState);
        },
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ------------------------------------------------
              // CALENDAR ICON
              // ------------------------------------------------
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: _green,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              // ------------------------------------------------
              // FILTER DETAILS
              // ------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATE RANGE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xff94A3B8),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _getFilterTitle(filterState),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff0F172A),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _getDateDescription(filterState),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // DROPDOWN ICON
              // ------------------------------------------------
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xff475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER BOTTOM SHEET
  // ============================================================

  void _showFilterBottomSheet(
    BuildContext context,
    WidgetRef ref,
    DashboardFilterState currentState,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --------------------------------------------
                  // DRAG HANDLE
                  // --------------------------------------------
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xffCBD5E1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --------------------------------------------
                  // TITLE
                  // --------------------------------------------
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _green.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(Icons.tune_rounded, color: _green),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Choose the period you want to view',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // --------------------------------------------
                  // QUICK FILTER GRID
                  // --------------------------------------------
                  Row(
                    children: [
                      Expanded(
                        child: _QuickFilterCard(
                          icon: Icons.today_rounded,
                          title: 'Today',
                          subtitle: 'Current day',
                          selected:
                              currentState.filter == DashboardDateFilter.today,
                          onTap: () {
                            Navigator.pop(bottomSheetContext);

                            ref.read(dashboardProvider.notifier).loadToday();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _QuickFilterCard(
                          icon: Icons.history_rounded,
                          title: 'Yesterday',
                          subtitle: 'Previous day',
                          selected:
                              currentState.filter ==
                              DashboardDateFilter.yesterday,
                          onTap: () {
                            Navigator.pop(bottomSheetContext);

                            ref
                                .read(dashboardProvider.notifier)
                                .loadYesterday();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _QuickFilterCard(
                          icon: Icons.date_range_rounded,
                          title: 'Last 7 Days',
                          subtitle: 'Recent week',
                          selected:
                              currentState.filter ==
                              DashboardDateFilter.last7Days,
                          onTap: () {
                            Navigator.pop(bottomSheetContext);

                            ref
                                .read(dashboardProvider.notifier)
                                .loadLast7Days();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _QuickFilterCard(
                          icon: Icons.calendar_view_month_rounded,
                          title: 'This Month',
                          subtitle: 'Month to date',
                          selected:
                              currentState.filter ==
                              DashboardDateFilter.thisMonth,
                          onTap: () {
                            Navigator.pop(bottomSheetContext);

                            ref
                                .read(dashboardProvider.notifier)
                                .loadThisMonth();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(height: 1, color: Color(0xffE2E8F0)),

                  const SizedBox(height: 16),

                  // --------------------------------------------
                  // CUSTOM RANGE
                  // --------------------------------------------
                  _LargeFilterTile(
                    icon: Icons.edit_calendar_rounded,
                    title: 'Custom Date Range',
                    subtitle: 'Choose your own start and end date',
                    selected: currentState.filter == DashboardDateFilter.custom,
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);

                      await _selectCustomDateRange(context, ref);
                    },
                  ),

                  const SizedBox(height: 10),

                  // --------------------------------------------
                  // ALL TIME
                  // --------------------------------------------
                  _LargeFilterTile(
                    icon: Icons.all_inclusive_rounded,
                    title: 'All Time',
                    subtitle: 'View all available order data',
                    selected:
                        currentState.filter == DashboardDateFilter.allTime,
                    onTap: () {
                      Navigator.pop(bottomSheetContext);

                      ref.read(dashboardProvider.notifier).loadAllTime();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CUSTOM DATE RANGE
  // ============================================================

  Future<void> _selectCustomDateRange(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentFilter = ref.read(dashboardFilterProvider);

    final range = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        return CustomDateRangePicker(
          initialStartDate: currentFilter.startDate,
          initialEndDate: currentFilter.endDate,
        );
      },
    );

    if (range == null) {
      return;
    }

    await ref
        .read(dashboardProvider.notifier)
        .loadCustomRange(startDate: range.start, endDate: range.end);
  }

  // ============================================================
  // LABELS
  // ============================================================

  String _getFilterTitle(DashboardFilterState state) {
    switch (state.filter) {
      case DashboardDateFilter.today:
        return 'Today';

      case DashboardDateFilter.yesterday:
        return 'Yesterday';

      case DashboardDateFilter.last7Days:
        return 'Last 7 Days';

      case DashboardDateFilter.thisMonth:
        return 'This Month';

      case DashboardDateFilter.custom:
        return 'Custom Range';

      case DashboardDateFilter.allTime:
        return 'All Time';
    }
  }

  String _getDateDescription(DashboardFilterState state) {
    if (state.filter == DashboardDateFilter.allTime) {
      return 'All available data';
    }

    if (state.startDate == null || state.endDate == null) {
      return '';
    }

    if (_isSameDay(state.startDate!, state.endDate!)) {
      return _formatDisplayDate(state.startDate!);
    }

    return '${_formatDisplayDate(state.startDate!)}'
        '  –  '
        '${_formatDisplayDate(state.endDate!)}';
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _formatDisplayDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

// ================================================================
// QUICK FILTER CARD
// ================================================================

class _QuickFilterCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _QuickFilterCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xff16A34A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? green.withValues(alpha: 0.07)
                : const Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? green : const Color(0xffE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected
                          ? green.withValues(alpha: 0.12)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: selected ? green : const Color(0xff64748B),
                    ),
                  ),

                  const Spacer(),

                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: green,
                      size: 20,
                    ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? green : const Color(0xff0F172A),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xff94A3B8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// LARGE FILTER TILE
// ================================================================

class _LargeFilterTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LargeFilterTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xff16A34A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? green.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? green : const Color(0xffE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? green.withValues(alpha: 0.12)
                      : const Color(0xffF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: selected ? green : const Color(0xff64748B),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected ? green : const Color(0xff0F172A),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              if (selected)
                const Icon(Icons.check_circle_rounded, color: green)
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xff94A3B8),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
