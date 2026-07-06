import '../../../menu/data/models/menu_item.dart';

class SelectedOrderItem {
  final MenuItemModel menuItem;

  final int quantity;

  final String? note;

  const SelectedOrderItem({
    required this.menuItem,
    this.quantity = 1,
    this.note,
  });

  double get total => menuItem.price * quantity;

  SelectedOrderItem copyWith({
    MenuItemModel? menuItem,
    int? quantity,
    String? note,
  }) {
    return SelectedOrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
