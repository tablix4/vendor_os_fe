enum OrderStatus { pending, completed }

extension OrderStatusExtension on OrderStatus {
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return "PENDING";

      case OrderStatus.completed:
        return "COMPLETED";
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return "Pending";

      case OrderStatus.completed:
        return "Completed";
    }
  }

  static OrderStatus fromApi(String? value) {
    switch ((value ?? "").toUpperCase()) {
      case "COMPLETED":
        return OrderStatus.completed;

      case "PENDING":
      default:
        return OrderStatus.pending;
    }
  }
}
