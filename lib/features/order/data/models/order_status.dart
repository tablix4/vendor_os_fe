enum OrderStatus { pending, done }

extension OrderStatusExtension on OrderStatus {
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return "PENDING";

      case OrderStatus.done:
        return "DONE";
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return "Pending";

      case OrderStatus.done:
        return "Done";
    }
  }

  static OrderStatus fromApi(String? value) {
    switch ((value ?? "").toUpperCase()) {
      case "DONE":
        return OrderStatus.done;

      case "PENDING":
      default:
        return OrderStatus.pending;
    }
  }
}
