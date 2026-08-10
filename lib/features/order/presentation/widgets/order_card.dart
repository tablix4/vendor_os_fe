import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/order_model.dart';
import '../../data/models/order_status.dart';

import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  final VoidCallback? onTap;

  final bool isUpdating;

  final VoidCallback? onMarkDone;

  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    required this.isUpdating,
    this.onTap,
    this.onMarkDone,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel =
        order.status == OrderStatus.pending ||
        order.status == OrderStatus.accepted;

    final canMarkDone =
        order.status != OrderStatus.completed &&
        order.status != OrderStatus.cancelled;

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
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName?.isNotEmpty == true
                          ? order.customerName!
                          : 'Walk-in Customer',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // IMPORTANT:
                  // OrderStatusBadge expects OrderStatus.
                  OrderStatusBadge(status: order.status),
                ],
              ),

              // ==================================================
              // PHONE
              // ==================================================
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

              // ==================================================
              // ITEMS + TOTAL
              // ==================================================
              Row(
                children: [
                  Text(
                    '${order.items.length} Items',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const Spacer(),

                  Text(
                    '₹${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DATE
              // ==================================================
              Text(
                DateFormat('dd MMM yyyy • hh:mm a').format(order.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              // ==================================================
              // ACTIONS
              // ==================================================
              if (canMarkDone && canCancel) ...[
                const SizedBox(height: 16),

                Row(
                  children: [
                    // ------------------------------------------
                    // MARK DONE
                    // ------------------------------------------
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: isUpdating ? null : onMarkDone,
                        icon: isUpdating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Mark Done'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // ------------------------------------------
                    // CANCEL
                    // ------------------------------------------
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isUpdating ? null : onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          side: const BorderSide(color: Color(0xFFFCA5A5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],

              // ==================================================
              // CANCELLED MESSAGE
              // ==================================================
              if (order.status == OrderStatus.cancelled) ...[
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.cancel_rounded,
                        size: 20,
                        color: Color(0xFFDC2626),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This order has been cancelled.',
                          style: TextStyle(
                            color: Color(0xFFB91C1C),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
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
