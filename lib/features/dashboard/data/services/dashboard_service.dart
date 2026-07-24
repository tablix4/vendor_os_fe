import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final Dio _dio = ApiClient.dio;

  Future<DashboardModel> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{};

    // Backend requires both dates together.
    if (startDate != null && endDate != null) {
      queryParameters['startDate'] = _formatDate(startDate);
      queryParameters['endDate'] = _formatDate(endDate);
    }

    final response = await _dio.get(
      ApiConstants.dashboard,
      queryParameters: queryParameters,
    );

    final data = response.data["data"];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception("Invalid dashboard response");
    }

    return DashboardModel.fromJson(data);
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
