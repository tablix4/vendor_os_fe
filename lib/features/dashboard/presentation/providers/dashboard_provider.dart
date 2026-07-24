import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardModel>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardModel> {
  final DashboardRepository _repository = DashboardRepository();

  @override
  Future<DashboardModel> build() async {
    return _repository.getDashboard();
  }

  Future<void> refreshDashboard() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getDashboard());
  }
}
