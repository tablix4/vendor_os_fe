import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final Dio _dio = ApiClient.dio;

  Future<DashboardModel> getDashboard() async {
    final response = await _dio.get(ApiConstants.dashboard);

    final data = response.data["data"];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception("Invalid dashboard response");
    }

    return DashboardModel.fromJson(data);
  }
}
