import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../menu/data/models/menu_item.dart';
import '../../data/models/create_order_request.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../state/order_state.dart';
import '../state/selected_order_item.dart';

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(
  OrderNotifier.new,
);

class OrderNotifier extends Notifier<OrderState> {
  final OrderRepository _repository = OrderRepository();
  int _ordersRequestSequence = 0;

  @override
  OrderState build() {
    Future.microtask(loadOrders);
    return const OrderState();
  }

  Future<void> loadOrders({bool loadMore = false, bool force = false}) async {
    if (!force) {
      if (state.isLoading || state.isRefreshing) {
        return;
      }
      if (loadMore && (state.isLoadingMore || !state.hasMore)) {
        return;
      }
    }

    final nextPage = loadMore ? state.page + 1 : 1;
    state = state.copyWith(
      isLoading: !loadMore && !force,
      isRefreshing: force && !loadMore,
      isLoadingMore: loadMore,
      error: null,
    );

    final currentRequestSequence = ++_ordersRequestSequence;

    try {
      final fetchedOrders = await _repository.getOrders(
        customerName: state.customerName,
        customerPhone: state.customerPhone,
        status: state.selectedStatus,
        page: nextPage,
        limit: state.limit,
      );

      if (currentRequestSequence != _ordersRequestSequence) {
        return;
      }

      final mergedOrders = loadMore
          ? [...state.orders, ...fetchedOrders]
          : fetchedOrders;

      state = state.copyWith(
        orders: mergedOrders,
        page: nextPage,
        total: mergedOrders.length,
        hasMore: fetchedOrders.length >= state.limit,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      if (currentRequestSequence != _ordersRequestSequence) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadOrders(force: true);
  }

  Future<void> searchCustomer(String value) async {
    final normalized = value.trim();
    state = state.copyWith(
      customerName: normalized.isEmpty ? null : normalized,
      page: 1,
      hasMore: true,
      error: null,
    );
    await loadOrders(force: true);
  }

  Future<void> searchPhone(String value) async {
    final normalized = value.trim();
    state = state.copyWith(
      customerPhone: normalized.isEmpty ? null : normalized,
      page: 1,
      hasMore: true,
      error: null,
    );
    await loadOrders(force: true);
  }

  Future<void> filterStatus(String? status) async {
    state = state.copyWith(
      selectedStatus: status,
      page: 1,
      hasMore: true,
      error: null,
    );
    await loadOrders(force: true);
  }

  Future<void> clearFilters() async {
    state = state.copyWith(
      customerName: null,
      customerPhone: null,
      selectedStatus: null,
      page: 1,
      hasMore: true,
      error: null,
    );
    await loadOrders(force: true);
  }

  void addItem(MenuItemModel menuItem) {
    final index = state.cart.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (index == -1) {
      state = state.copyWith(
        cart: [
          ...state.cart,
          SelectedOrderItem(menuItem: menuItem, quantity: 1),
        ],
      );
      return;
    }

    final updatedCart = [...state.cart];
    final selected = updatedCart[index];
    updatedCart[index] = selected.copyWith(quantity: selected.quantity + 1);
    state = state.copyWith(cart: updatedCart);
  }

  void increaseQuantity(String menuItemId) {
    final index = state.cart.indexWhere(
      (item) => item.menuItem.id == menuItemId,
    );
    if (index == -1) {
      return;
    }

    final updatedCart = [...state.cart];
    final selected = updatedCart[index];
    updatedCart[index] = selected.copyWith(quantity: selected.quantity + 1);
    state = state.copyWith(cart: updatedCart);
  }

  void decreaseQuantity(String menuItemId) {
    final index = state.cart.indexWhere(
      (item) => item.menuItem.id == menuItemId,
    );
    if (index == -1) {
      return;
    }

    final updatedCart = [...state.cart];
    final selected = updatedCart[index];
    if (selected.quantity <= 1) {
      updatedCart.removeAt(index);
    } else {
      updatedCart[index] = selected.copyWith(quantity: selected.quantity - 1);
    }
    state = state.copyWith(cart: updatedCart);
  }

  void removeItem(String menuItemId) {
    final updatedCart = state.cart
        .where((item) => item.menuItem.id != menuItemId)
        .toList();
    state = state.copyWith(cart: updatedCart);
  }

  void clearCart() {
    state = state.copyWith(cart: const []);
  }

  int getQuantity(String menuItemId) {
    for (final item in state.cart) {
      if (item.menuItem.id == menuItemId) {
        return item.quantity;
      }
    }
    return 0;
  }

  Future<void> createOrder(CreateOrderRequest request) async {
    state = state.copyWith(isCreatingOrder: true, error: null);

    try {
      await _repository.createOrder(request);
      state = state.copyWith(cart: const [], isCreatingOrder: false);
      await refresh();
    } catch (e) {
      state = state.copyWith(isCreatingOrder: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    state = state.copyWith(updatingOrderId: orderId, error: null);

    try {
      await _repository.updateOrderStatus(orderId: orderId, status: status);
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(updatingOrderId: null);
    }
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final order = await _repository.getOrderById(orderId);
      state = state.copyWith(selectedOrder: order, error: null);
      return order;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}
