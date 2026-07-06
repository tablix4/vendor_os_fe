import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../providers/order_provider.dart';

class OrderSummaryCard extends ConsumerWidget {
  final bool loading;
  final VoidCallback onPlaceOrder;

  const OrderSummaryCard({
    super.key,
    required this.loading,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SummaryRow(
              title: "Unique Items",
              value: orderState.uniqueItems.toString(),
            ),

            const SizedBox(height: 12),

            _SummaryRow(
              title: "Total Quantity",
              value: orderState.totalItems.toString(),
            ),

            const Divider(height: 30),

            _SummaryRow(
              title: "Subtotal",
              value: "₹${orderState.subtotal.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            _SummaryRow(
              title: "Tax",
              value: "₹${orderState.tax.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            _SummaryRow(
              title: "Discount",
              value: "- ₹${orderState.discount.toStringAsFixed(2)}",
            ),

            const Divider(height: 30),

            _SummaryRow(
              title: "Grand Total",
              value: "₹${orderState.grandTotal.toStringAsFixed(2)}",
              isTotal: true,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: "Place Order",
                loading: loading,
                onPressed: orderState.totalItems == 0 ? null : onPlaceOrder,
              ),
            ),
          ],
        ),
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
      fontSize: isTotal ? 22 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
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
