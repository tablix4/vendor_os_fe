import 'package:flutter/material.dart';

import '../../../order/data/models/order_status.dart';

class RecentOrderTile extends StatelessWidget {
  final String orderNo;
  final String customer;
  final String amount;
  final OrderStatus status;

  const RecentOrderTile({
    super.key,
    required this.orderNo,
    required this.customer,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == OrderStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xff16A34A).withValues(alpha: .12),
            child: const Icon(Icons.shopping_bag, color: Color(0xff16A34A)),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(customer, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status.displayName,
                  style: TextStyle(
                    color: isPending ? Colors.orange.shade800 : Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
