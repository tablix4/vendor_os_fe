import '../../data/models/order_model.dart';
import 'selected_order_item.dart';

class OrderState {
  static const Object _unset = Object();

  final List<OrderModel> orders;
  final List<SelectedOrderItem> cart;
  final OrderModel? selectedOrder;

  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isCreatingOrder;

  final String? updatingOrderId;

  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  final String? customerName;
  final String? customerPhone;
  final String? selectedStatus;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.cart = const [],
    this.selectedOrder,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isCreatingOrder = false,
    this.updatingOrderId,
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.hasMore = true,
    this.customerName,
    this.customerPhone,
    this.selectedStatus,
    this.error,
  });

  double get subtotal => cart.fold(0, (sum, item) => sum + item.total);

  int get totalItems => cart.fold(0, (sum, item) => sum + item.quantity);

  int get uniqueItems => cart.length;

  double get tax => 0;

  double get discount => 0;

  double get grandTotal => subtotal + tax - discount;

  bool get hasItems => cart.isNotEmpty;

  OrderState copyWith({
    List<OrderModel>? orders,
    List<SelectedOrderItem>? cart,
    Object? selectedOrder = _unset,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isCreatingOrder,
    Object? updatingOrderId = _unset,
    int? page,
    int? limit,
    int? total,
    bool? hasMore,
    Object? customerName = _unset,
    Object? customerPhone = _unset,
    Object? selectedStatus = _unset,
    Object? error = _unset,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      cart: cart ?? this.cart,
      selectedOrder: identical(selectedOrder, _unset)
          ? this.selectedOrder
          : selectedOrder as OrderModel?,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isCreatingOrder: isCreatingOrder ?? this.isCreatingOrder,
      updatingOrderId: identical(updatingOrderId, _unset)
          ? this.updatingOrderId
          : updatingOrderId as String?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      customerName: identical(customerName, _unset)
          ? this.customerName
          : customerName as String?,
      customerPhone: identical(customerPhone, _unset)
          ? this.customerPhone
          : customerPhone as String?,
      selectedStatus: identical(selectedStatus, _unset)
          ? this.selectedStatus
          : selectedStatus as String?,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
