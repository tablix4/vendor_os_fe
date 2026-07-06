import '../../../menu/data/models/menu_item.dart';

class OrderItemModel {
  final String id;
  final int quantity;
  final double price;
  final MenuItemModel menuItem;

  const OrderItemModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.menuItem,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] == null
          ? 0
          : double.tryParse(json['price'].toString()) ?? 0,
      menuItem: MenuItemModel.fromJson(
        json['menuItem'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'menuItem': menuItem.toJson(),
    };
  }
}
