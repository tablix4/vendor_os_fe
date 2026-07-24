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
    final rawItems = json['items'];

    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(OrderModel.fromJson)
              .toList()
        : <OrderModel>[];

    return OrderListResponse(
      items: items,
      page: int.tryParse(json['page']?.toString() ?? '') ?? 1,
      limit: int.tryParse(json['limit']?.toString() ?? '') ?? 20,
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
    );
  }
}
