import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status.toUpperCase() == "PENDING";

    final backgroundColor = isPending
        ? Colors.orange.withValues(alpha: .12)
        : Colors.green.withValues(alpha: .12);

    final textColor = isPending
        ? Colors.orange.shade700
        : Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPending ? "Pending" : "Completed",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
