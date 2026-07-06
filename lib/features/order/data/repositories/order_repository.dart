import '../models/order_model.dart';
import '../services/order_service.dart';
import '../models/create_order_request.dart';

class OrderRepository {
  final OrderService _service = OrderService();

  Future<List<OrderModel>> getOrders({
    String? customerName,
    String? customerPhone,
    String? status,
    int page = 1,
    int limit = 20,
  }) {
    return _service.getOrders(
      customerName: customerName,
      customerPhone: customerPhone,
      status: status,
      page: page,
      limit: limit,
    );
  }

  Future<OrderModel> getOrderById(String id) {
    return _service.getOrderById(id);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) {
    return _service.updateOrderStatus(orderId: orderId, status: status);
  }

  Future<void> createOrder(CreateOrderRequest request) {
    return _service.createOrder(request);
  }
}
