import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/order_status.dart';

import '../providers/order_provider.dart';
import '../widgets/order_card.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final TextEditingController _customerSearchController =
      TextEditingController();

  final TextEditingController _phoneSearchController = TextEditingController();

  Timer? _customerDebounce;
  Timer? _phoneDebounce;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 7, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }

      final notifier = ref.read(orderProvider.notifier);

      switch (_tabController.index) {
        case 0:
          notifier.filterStatus(null);
          break;

        case 1:
          notifier.filterStatus(OrderStatus.pending.apiValue);
          break;

        case 2:
          notifier.filterStatus(OrderStatus.accepted.apiValue);
          break;

        case 3:
          notifier.filterStatus(OrderStatus.preparing.apiValue);
          break;

        case 4:
          notifier.filterStatus(OrderStatus.ready.apiValue);
          break;

        case 5:
          notifier.filterStatus(OrderStatus.completed.apiValue);
          break;

        case 6:
          notifier.filterStatus(OrderStatus.cancelled.apiValue);
          break;
      }
    });
  }

  @override
  void dispose() {
    _customerDebounce?.cancel();
    _phoneDebounce?.cancel();

    _customerSearchController.dispose();
    _phoneSearchController.dispose();

    _tabController.dispose();

    super.dispose();
  }

  // ============================================================
  // CUSTOMER SEARCH
  // ============================================================

  void _onCustomerChanged(String value) {
    _customerDebounce?.cancel();

    _customerDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(orderProvider.notifier).searchCustomer(value);
    });
  }

  // ============================================================
  // PHONE SEARCH
  // ============================================================

  void _onPhoneChanged(String value) {
    _phoneDebounce?.cancel();

    _phoneDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(orderProvider.notifier).searchPhone(value);
    });
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 250) {
      final orderState = ref.read(orderProvider);

      if (!orderState.isLoadingMore &&
          orderState.hasMore &&
          !orderState.isLoading &&
          !orderState.isRefreshing) {
        ref.read(orderProvider.notifier).loadOrders(loadMore: true);
      }
    }

    return false;
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  void _clearAllFilters() {
    _customerSearchController.clear();
    _phoneSearchController.clear();

    _tabController.animateTo(0);

    ref.read(orderProvider.notifier).clearFilters();
  }

  // ============================================================
  // CANCEL CONFIRMATION
  // ============================================================

  Future<bool> _showCancelConfirmation(
    BuildContext context,
    String? customerName,
  ) async {
    final name = customerName?.trim().isNotEmpty == true
        ? customerName!.trim()
        : 'this order';

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
              SizedBox(width: 10),
              Expanded(child: Text('Cancel Order?')),
            ],
          ),
          content: Text('Are you sure you want to cancel the order for $name?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Keep Order'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Cancel Order'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    final notifier = ref.read(orderProvider.notifier);

    final orders = orderState.orders;

    Widget listSection;

    // ==========================================================
    // LOADING
    // ==========================================================

    if (orderState.isLoading && orders.isEmpty) {
      listSection = const Center(child: CircularProgressIndicator());
    }
    // ==========================================================
    // ERROR
    // ==========================================================
    else if (orderState.error != null && orders.isEmpty) {
      listSection = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),

              const SizedBox(height: 16),

              Text(orderState.error!, textAlign: TextAlign.center),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: notifier.refresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    // ==========================================================
    // EMPTY
    // ==========================================================
    else if (orders.isEmpty) {
      listSection = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),

          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey),

          SizedBox(height: 20),

          Center(
            child: Text(
              'No Orders Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 8),

          Center(child: Text('Orders will appear here.')),
        ],
      );
    }
    // ==========================================================
    // ORDER LIST
    // ==========================================================
    else {
      listSection = NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: orders.length + (orderState.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            if (index >= orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final order = orders[index];

            return OrderCard(
              order: order,

              isUpdating: orderState.updatingOrderId == order.id,

              // ----------------------------------------------
              // OPEN DETAILS
              // ----------------------------------------------
              onTap: () {
                context.push('/orders/${order.id}');
              },

              // ----------------------------------------------
              // MARK DONE
              // ----------------------------------------------
              onMarkDone: () async {
                await notifier.updateOrderStatus(
                  orderId: order.id,
                  status: OrderStatus.completed.apiValue,
                );
              },

              // ----------------------------------------------
              // CANCEL
              // ----------------------------------------------
              onCancel: () async {
                final confirmed = await _showCancelConfirmation(
                  context,
                  order.customerName,
                );

                if (!confirmed) {
                  return;
                }

                try {
                  await notifier.cancelOrder(order.id);

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order cancelled successfully'),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to cancel order')),
                  );
                }
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: false,

        actions: [
          IconButton(
            tooltip: 'Clear Filters',
            onPressed: _clearAllFilters,
            icon: const Icon(Icons.filter_alt_off_outlined),
          ),
        ],

        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Preparing'),
            Tab(text: 'Ready'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),

      body: Column(
        children: [
          if (orderState.isRefreshing)
            const LinearProgressIndicator(minHeight: 2),

          Expanded(
            child: RefreshIndicator(
              onRefresh: notifier.refresh,
              child: listSection,
            ),
          ),
        ],
      ),
    );
  }
}
