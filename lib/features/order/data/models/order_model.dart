import 'order_item_model.dart';
import 'order_status.dart';

class OrderModel {
  final String id;
  final String? customerName;
  final String? customerPhone;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    this.customerName,
    this.customerPhone,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      total: json['total'] == null
          ? 0
          : double.tryParse(json['total'].toString()) ?? 0,
      status: OrderStatusExtension.fromApi(json['status']),
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'total': total,
      'status': status.apiValue,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
