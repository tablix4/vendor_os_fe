enum OrderStatus { pending, accepted, preparing, ready, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';

      case OrderStatus.accepted:
        return 'ACCEPTED';

      case OrderStatus.preparing:
        return 'PREPARING';

      case OrderStatus.ready:
        return 'READY';

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

      case OrderStatus.accepted:
        return 'Accepted';

      case OrderStatus.preparing:
        return 'Preparing';

      case OrderStatus.ready:
        return 'Ready';

      case OrderStatus.completed:
        return 'Completed';

      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromApi(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'ACCEPTED':
        return OrderStatus.accepted;

      case 'PREPARING':
        return OrderStatus.preparing;

      case 'READY':
        return OrderStatus.ready;

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
