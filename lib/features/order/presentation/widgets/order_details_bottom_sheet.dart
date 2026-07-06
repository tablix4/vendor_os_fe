import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import 'order_status_badge.dart';

class OrderDetailsBottomSheet extends ConsumerWidget {
  final OrderModel order;

  const OrderDetailsBottomSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = order.status.name.toUpperCase() == "PENDING";
    final isUpdating = ref.watch(
      orderProvider.select((state) => state.updatingOrderId == order.id),
    );

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .80,
        minChildSize: .50,
        maxChildSize: .95,
        snap: true,
        snapSizes: const [.80, .95],
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.customerName?.isEmpty ?? true
                            ? "Walk-in Customer"
                            : order.customerName!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    OrderStatusBadge(status: order.status.name.toUpperCase()),
                  ],
                ),

                if (order.customerPhone != null &&
                    order.customerPhone!.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.phone),

                      const SizedBox(width: 8),

                      Text(order.customerPhone!),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                const Text(
                  "Items",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 12),

                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.menuItem.name)),

                        Text(
                          "${item.quantity} x ₹${item.price.toStringAsFixed(0)}",
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "₹${(item.price * item.quantity).toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32),

                Row(
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "₹${order.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  DateFormat("dd MMM yyyy • hh:mm a").format(order.createdAt),
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 32),

                if (isPending)
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              await ref
                                  .read(orderProvider.notifier)
                                  .updateOrderStatus(
                                    orderId: order.id,
                                    status: "DONE",
                                  );

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      icon: isUpdating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(isUpdating ? "Updating..." : "Mark as Done"),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
