import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';

// ============================================================
// DASHBOARD FILTER TYPES
// ============================================================

enum DashboardDateFilter {
  today,
  yesterday,
  last7Days,
  thisMonth,
  custom,
  allTime,
}

// ============================================================
// FILTER STATE
// ============================================================

class DashboardFilterState {
  final DashboardDateFilter filter;
  final DateTime? startDate;
  final DateTime? endDate;

  const DashboardFilterState({
    this.filter = DashboardDateFilter.today,
    this.startDate,
    this.endDate,
  });

  DashboardFilterState copyWith({
    DashboardDateFilter? filter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DashboardFilterState(
      filter: filter ?? this.filter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// ============================================================
// FILTER PROVIDER
// ============================================================

class DashboardFilterNotifier extends Notifier<DashboardFilterState> {
  @override
  DashboardFilterState build() {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    return DashboardFilterState(
      filter: DashboardDateFilter.today,
      startDate: today,
      endDate: today,
    );
  }

  void update(DashboardFilterState newState) {
    state = newState;
  }
}

final dashboardFilterProvider =
    NotifierProvider<DashboardFilterNotifier, DashboardFilterState>(
      DashboardFilterNotifier.new,
    );

// ============================================================
// DASHBOARD PROVIDER
// ============================================================

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardModel>(
      DashboardNotifier.new,
    );

// ============================================================
// DASHBOARD NOTIFIER
// ============================================================

class DashboardNotifier extends AsyncNotifier<DashboardModel> {
  final DashboardRepository _repository = DashboardRepository();

  // ==========================================================
  // INITIAL LOAD
  // ==========================================================

  @override
  Future<DashboardModel> build() async {
    // Dashboard displays TODAY'S data by default.

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    return _repository.getDashboard(startDate: today, endDate: today);
  }

  // ==========================================================
  // TODAY
  // ==========================================================

  Future<void> loadToday() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    ref.read(dashboardFilterProvider.notifier).state = DashboardFilterState(
      filter: DashboardDateFilter.today,
      startDate: today,
      endDate: today,
    );

    await _loadDashboard(startDate: today, endDate: today);
  }

  // ==========================================================
  // YESTERDAY
  // ==========================================================

  Future<void> loadYesterday() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final yesterday = today.subtract(const Duration(days: 1));

    ref.read(dashboardFilterProvider.notifier).state = DashboardFilterState(
      filter: DashboardDateFilter.yesterday,
      startDate: yesterday,
      endDate: yesterday,
    );

    await _loadDashboard(startDate: yesterday, endDate: yesterday);
  }

  // ==========================================================
  // LAST 7 DAYS
  // ==========================================================

  Future<void> loadLast7Days() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    // Inclusive:
    // today + previous 6 days = 7 days.
    final startDate = today.subtract(const Duration(days: 6));

    ref.read(dashboardFilterProvider.notifier).state = DashboardFilterState(
      filter: DashboardDateFilter.last7Days,
      startDate: startDate,
      endDate: today,
    );

    await _loadDashboard(startDate: startDate, endDate: today);
  }

  // ==========================================================
  // THIS MONTH
  // ==========================================================

  Future<void> loadThisMonth() async {
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, 1);

    final today = DateTime(now.year, now.month, now.day);

    ref.read(dashboardFilterProvider.notifier).state = DashboardFilterState(
      filter: DashboardDateFilter.thisMonth,
      startDate: startDate,
      endDate: today,
    );

    await _loadDashboard(startDate: startDate, endDate: today);
  }

  // ==========================================================
  // CUSTOM RANGE
  // ==========================================================

  Future<void> loadCustomRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

    if (normalizedStart.isAfter(normalizedEnd)) {
      throw Exception('Start date cannot be greater than end date');
    }

    ref.read(dashboardFilterProvider.notifier).state = DashboardFilterState(
      filter: DashboardDateFilter.custom,
      startDate: normalizedStart,
      endDate: normalizedEnd,
    );

    await _loadDashboard(startDate: normalizedStart, endDate: normalizedEnd);
  }

  // ==========================================================
  // ALL TIME
  // ==========================================================

  Future<void> loadAllTime() async {
    ref
        .read(dashboardFilterProvider.notifier)
        .state = const DashboardFilterState(
      filter: DashboardDateFilter.allTime,
      startDate: null,
      endDate: null,
    );

    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getDashboard());
  }

  // ==========================================================
  // COMMON API LOADER
  // ==========================================================

  Future<void> _loadDashboard({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getDashboard(startDate: startDate, endDate: endDate),
    );
  }

  // ==========================================================
  // REFRESH CURRENT FILTER
  // ==========================================================

  Future<void> refreshDashboard() async {
    final filterState = ref.read(dashboardFilterProvider);

    if (filterState.filter == DashboardDateFilter.allTime) {
      state = const AsyncLoading();

      state = await AsyncValue.guard(() => _repository.getDashboard());

      return;
    }

    if (filterState.startDate != null && filterState.endDate != null) {
      await _loadDashboard(
        startDate: filterState.startDate!,
        endDate: filterState.endDate!,
      );

      return;
    }

    // Fallback to today.
    await loadToday();
  }
}
