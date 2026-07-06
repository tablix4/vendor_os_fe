class CreateOrderItem {
  final String menuItemId;
  final int quantity;

  const CreateOrderItem({required this.menuItemId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {"menuItemId": menuItemId, "quantity": quantity};
  }

  CreateOrderItem copyWith({String? menuItemId, int? quantity}) {
    return CreateOrderItem(
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
    );
  }
}
