import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service = DashboardService();

  Future<DashboardModel> getDashboard() {
    return _service.getDashboard();
  }
}
