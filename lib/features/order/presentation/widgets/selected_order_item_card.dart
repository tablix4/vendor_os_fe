import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/order_provider.dart';
import '../state/selected_order_item.dart';

class SelectedOrderItemCard extends ConsumerWidget {
  final SelectedOrderItem item;

  const SelectedOrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderProvider.notifier);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.menuItem.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${item.menuItem.price.toStringAsFixed(2)} each",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Total : ₹${item.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff16A34A),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        notifier.decreaseQuantity(item.menuItem.id),
                    icon: const Icon(Icons.remove),
                  ),

                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () =>
                        notifier.increaseQuantity(item.menuItem.id),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            IconButton(
              tooltip: "Remove item",
              onPressed: () => notifier.removeItem(item.menuItem.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
