import 'package:flutter/material.dart';

import '../../data/models/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  Color get backgroundColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFF7E6);

      case OrderStatus.accepted:
        return const Color(0xFFEAF4FF);

      case OrderStatus.preparing:
        return const Color(0xFFF3EFFF);

      case OrderStatus.ready:
        return const Color(0xFFEAFBF2);

      case OrderStatus.completed:
        return const Color(0xFFE8F7EE);

      case OrderStatus.cancelled:
        return const Color(0xFFFFEAEA);
    }
  }

  Color get foregroundColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFD97706);

      case OrderStatus.accepted:
        return const Color(0xFF2563EB);

      case OrderStatus.preparing:
        return const Color(0xFF7C3AED);

      case OrderStatus.ready:
        return const Color(0xFF059669);

      case OrderStatus.completed:
        return const Color(0xFF16A34A);

      case OrderStatus.cancelled:
        return const Color(0xFFDC2626);
    }
  }

  IconData get icon {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule_rounded;

      case OrderStatus.accepted:
        return Icons.thumb_up_alt_outlined;

      case OrderStatus.preparing:
        return Icons.restaurant_rounded;

      case OrderStatus.ready:
        return Icons.room_service_outlined;

      case OrderStatus.completed:
        return Icons.check_circle_outline_rounded;

      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            status.displayName,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
