import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/order_model.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  final VoidCallback? onTap;
  final bool isUpdating;
  final VoidCallback? onMarkDone;

  const OrderCard({
    super.key,
    required this.order,
    required this.isUpdating,
    this.onTap,
    this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = order.status.name.toUpperCase() == "PENDING";

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName?.isNotEmpty == true
                          ? order.customerName!
                          : "Walk-in Customer",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
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
                    const Icon(Icons.phone, size: 18),

                    const SizedBox(width: 6),

                    Text(order.customerPhone!),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    "${order.items.length} Items",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const Spacer(),

                  Text(
                    "₹${order.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                DateFormat("dd MMM yyyy • hh:mm a").format(order.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              if (isPending) ...[
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isUpdating ? null : onMarkDone,
                    child: isUpdating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Mark Done"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
