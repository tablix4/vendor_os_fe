import 'order_model.dart';

class OrderListResponse {
  final List<OrderModel> items;
  final int page;
  final int limit;
  final int total;

  const OrderListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool get hasMore => page * limit < total;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      page: json['page'] ?? 1,

      limit: json['limit'] ?? 20,

      total: json['total'] ?? 0,
    );
  }
}
