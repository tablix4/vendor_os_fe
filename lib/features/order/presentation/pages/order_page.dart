import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    _tabController = TabController(length: 3, vsync: this);

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
          notifier.filterStatus("PENDING");
          break;
        case 2:
          notifier.filterStatus("COMPLETED");
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

  void _onCustomerChanged(String value) {
    _customerDebounce?.cancel();
    _customerDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(orderProvider.notifier).searchCustomer(value);
    });
  }

  void _onPhoneChanged(String value) {
    _phoneDebounce?.cancel();
    _phoneDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(orderProvider.notifier).searchPhone(value);
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        (notification.metrics.maxScrollExtent - 250)) {
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

  void _clearAllFilters() {
    _customerSearchController.clear();
    _phoneSearchController.clear();
    _tabController.animateTo(0);
    ref.read(orderProvider.notifier).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final notifier = ref.read(orderProvider.notifier);
    final orders = orderState.orders;

    Widget listSection;
    if (orderState.isLoading && orders.isEmpty) {
      listSection = const Center(child: CircularProgressIndicator());
    } else if (orderState.error != null && orders.isEmpty) {
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
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    } else if (orders.isEmpty) {
      listSection = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey),
          SizedBox(height: 20),
          Center(
            child: Text(
              "No Orders Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(child: Text("Orders will appear here.")),
        ],
      );
    } else {
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
              onTap: () => context.push('/orders/${order.id}/status'),
              onMarkDone: () async {
                await notifier.updateOrderStatus(
                  orderId: order.id,
                  status: "COMPLETED",
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: "Clear Filters",
            onPressed: _clearAllFilters,
            icon: const Icon(Icons.filter_alt_off_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Pending"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: Column(
        children: [
          if (orderState.isRefreshing)
            const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                // ValueListenableBuilder<TextEditingValue>(
                //   valueListenable: _customerSearchController,
                //   builder: (context, value, _) {
                //     return TextField(
                //       controller: _customerSearchController,
                //       onChanged: _onCustomerChanged,
                //       textInputAction: TextInputAction.search,
                //       decoration: InputDecoration(
                //         labelText: "Search Customer r",
                //         hintText: "Customer name",
                //         prefixIcon: const Icon(Icons.person_search_outlined),
                //         suffixIcon: value.text.isEmpty
                //             ? null
                //             : IconButton(
                //                 onPressed: () {
                //                   _customerSearchController.clear();
                //                   _onCustomerChanged('');
                //                 },
                //                 icon: const Icon(Icons.close),
                //               ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //     );
                // },
                // ),
                // const SizedBox(height: 10),
                // ValueListenableBuilder<TextEditingValue>(
                //   valueListenable: _phoneSearchController,
                //   builder: (context, value, _) {
                //     return TextField(
                //       controller: _phoneSearchController,
                //       keyboardType: TextInputType.phone,
                //       onChanged: _onPhoneChanged,
                //       textInputAction: TextInputAction.search,
                //       decoration: InputDecoration(
                //         labelText: "Search Phone",
                //         hintText: "Phone number",
                //         prefixIcon: const Icon(Icons.phone_outlined),
                //         suffixIcon: value.text.isEmpty
                //             ? null
                //             : IconButton(
                //                 onPressed: () {
                //                   _phoneSearchController.clear();
                //                   _onPhoneChanged('');
                //                 },
                //                 icon: const Icon(Icons.close),
                //               ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
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
