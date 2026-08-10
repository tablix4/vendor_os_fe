enum OrderStatus { pending, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';

      case OrderStatus.completed:
        return 'COMPLETED';

      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';

      case OrderStatus.completed:
        return 'Completed';

      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromApi(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'COMPLETED':
        return OrderStatus.completed;

      case 'CANCELLED':
        return OrderStatus.cancelled;

      case 'PENDING':
      default:
        return OrderStatus.pending;
    }
  }
}
