import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service = DashboardService();

  Future<DashboardModel> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _service.getDashboard(startDate: startDate, endDate: endDate);
  }
}
