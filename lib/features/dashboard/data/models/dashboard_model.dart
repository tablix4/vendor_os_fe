import '../../../order/data/models/order_model.dart';

class DashboardModel {
  final double totalSales;
  final int totalOrders;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;
  final int completedOrders;
  final int totalMenuItems;
  final int totalCategories;
  final List<OrderModel> recentOrders;

  const DashboardModel({
    required this.totalSales,
    required this.totalOrders,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.completedOrders,
    required this.totalMenuItems,
    required this.totalCategories,
    required this.recentOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final recentOrdersJson = json["recentOrders"] as List<dynamic>? ?? [];

    return DashboardModel(
      totalSales: double.tryParse(json["totalSales"]?.toString() ?? "0") ?? 0,

      totalOrders: int.tryParse(json["totalOrders"]?.toString() ?? "0") ?? 0,

      pendingOrders:
          int.tryParse(json["pendingOrders"]?.toString() ?? "0") ?? 0,

      preparingOrders:
          int.tryParse(json["preparingOrders"]?.toString() ?? "0") ?? 0,

      readyOrders: int.tryParse(json["readyOrders"]?.toString() ?? "0") ?? 0,

      completedOrders:
          int.tryParse(json["completedOrders"]?.toString() ?? "0") ?? 0,

      totalMenuItems:
          int.tryParse(json["totalMenuItems"]?.toString() ?? "0") ?? 0,

      totalCategories:
          int.tryParse(json["totalCategories"]?.toString() ?? "0") ?? 0,

      recentOrders: recentOrdersJson
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList(),
    );
  }
}
