import 'create_order_item.dart';

class CreateOrderRequest {
  final String? customerName;
  final String? customerPhone;
  final List<CreateOrderItem> items;

  const CreateOrderRequest({
    this.customerName,
    this.customerPhone,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      if (customerName != null && customerName!.isNotEmpty)
        "customerName": customerName,

      if (customerPhone != null && customerPhone!.isNotEmpty)
        "customerPhone": customerPhone,

      "items": items.map((item) => item.toJson()).toList(),
    };
  }

  CreateOrderRequest copyWith({
    String? customerName,
    String? customerPhone,
    List<CreateOrderItem>? items,
  }) {
    return CreateOrderRequest(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
    );
  }
}
