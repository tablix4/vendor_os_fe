import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

import '../models/create_order_request.dart';
import '../models/order_model.dart';

class OrderService {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // GET ORDERS
  // ============================================================

  Future<List<OrderModel>> getOrders({
    String? customerName,
    String? customerPhone,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.orders,
      queryParameters: {
        'page': page,
        'limit': limit,

        if (customerName != null && customerName.isNotEmpty)
          'customerName': customerName,

        if (customerPhone != null && customerPhone.isNotEmpty)
          'customerPhone': customerPhone,

        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    final List items = response.data['data']['items'];

    return items
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ============================================================
  // GET ORDER DETAILS
  // ============================================================

  Future<OrderModel> getOrderById(String orderId) async {
    final response = await _dio.get('${ApiConstants.orders}/$orderId');

    return OrderModel.fromJson(response.data['data']);
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _dio.patch(
      '${ApiConstants.orders}/$orderId/status',
      data: {'status': status},
    );
  }

  // ============================================================
  // CREATE ORDER
  // ============================================================

  Future<void> createOrder(CreateOrderRequest request) async {
    await _dio.post(ApiConstants.orders, data: request.toJson());
  }

  // ============================================================
  // CANCEL ORDER
  //
  // Separate backend endpoint.
  // ============================================================

  Future<void> cancelOrder(String orderId) async {
    await _dio.patch('${ApiConstants.orders}/$orderId/cancel');
  }
}
