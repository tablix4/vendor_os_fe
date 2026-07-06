import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../menu/data/models/menu_item.dart';
import '../providers/order_provider.dart';

class MenuItemSelectorCard extends ConsumerWidget {
  final MenuItemModel item;

  const MenuItemSelectorCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(
      orderProvider.select((state) {
        final index = state.cart.indexWhere(
          (selected) => selected.menuItem.id == item.id,
        );
        if (index == -1) {
          return 0;
        }
        return state.cart[index].quantity;
      }),
    );
    final notifier = ref.read(orderProvider.notifier);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: item.isAvailable
                    ? const Color(0xffF3F4F6)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restaurant_menu, color: Colors.orange),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${item.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff16A34A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.isAvailable
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.isAvailable ? "Available" : "Unavailable",
                      style: TextStyle(
                        color: item.isAvailable
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (item.isAvailable)
              quantity == 0
                  ? FilledButton(
                      onPressed: () => notifier.addItem(item),
                      child: const Text("Add"),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => notifier.decreaseQuantity(item.id),
                            icon: const Icon(Icons.remove),
                          ),

                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          IconButton(
                            onPressed: () => notifier.increaseQuantity(item.id),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
