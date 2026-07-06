import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/order_status_badge.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  late Future<OrderModel> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<OrderModel> _loadDetails() {
    return ref.read(orderProvider.notifier).getOrderDetails(widget.orderId);
  }

  double _calculateSubtotal(OrderModel order) {
    return order.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: FutureBuilder<OrderModel>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _detailsFuture = _loadDetails();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final order = snapshot.data;
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }

          final subtotal = _calculateSubtotal(order);
          const discount = 0.0;
          const tax = 0.0;
          final grandTotal = subtotal + tax - discount;
          final isPending = order.status.name.toUpperCase() == "PENDING";
          final isUpdating = ref.watch(
            orderProvider.select((state) => state.updatingOrderId == order.id),
          );

          return RefreshIndicator(
            onRefresh: () async {
              final updated = await _loadDetails();
              setState(() {
                _detailsFuture = Future<OrderModel>.value(updated);
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                order.customerName?.isNotEmpty == true
                                    ? order.customerName!
                                    : 'Walk-in Customer',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            OrderStatusBadge(
                              status: order.status.name.toUpperCase(),
                            ),
                          ],
                        ),
                        if (order.customerPhone?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 18),
                              const SizedBox(width: 6),
                              Text(order.customerPhone!),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          DateFormat(
                            "dd MMM yyyy • hh:mm a",
                          ).format(order.createdAt),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(child: Text(item.menuItem.name)),
                          Text(
                            '${item.quantity} x ₹${item.price.toStringAsFixed(2)}',
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '₹${(item.quantity * item.price).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SummaryRow(
                          title: 'Subtotal',
                          value: '₹${subtotal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        const _SummaryRow(title: 'Tax', value: '₹0.00'),
                        const SizedBox(height: 10),
                        const _SummaryRow(title: 'Discount', value: '- ₹0.00'),
                        const Divider(height: 24),
                        _SummaryRow(
                          title: 'Grand Total',
                          value: '₹${grandTotal.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isPending) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              await ref
                                  .read(orderProvider.notifier)
                                  .updateOrderStatus(
                                    orderId: order.id,
                                    status: "DONE",
                                  );
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                _detailsFuture = _loadDetails();
                              });
                            },
                      icon: isUpdating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        isUpdating ? 'Updating...' : 'Mark as Completed',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isTotal ? 20 : 15,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      children: [
        Text(title, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
