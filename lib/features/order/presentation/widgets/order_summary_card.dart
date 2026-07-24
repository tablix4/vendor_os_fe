import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../providers/order_provider.dart';

class OrderSummaryCard extends ConsumerWidget {
  final bool loading;
  final bool isExpanded;
  final VoidCallback onToggle;

  const OrderSummaryCard({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.loading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Container(
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
            // --------------------------------------------------
            // COLLAPSED HEADER
            // Always visible
            // --------------------------------------------------
            InkWell(
              onTap: onToggle,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "₹${orderState.grandTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 10),

                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --------------------------------------------------
            // EXPANDABLE CONTENT
            // --------------------------------------------------
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(height: 1),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
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
                                value:
                                    "₹${orderState.subtotal.toStringAsFixed(2)}",
                              ),

                              const SizedBox(height: 10),

                              _SummaryRow(
                                title: "Tax",
                                value: "₹${orderState.tax.toStringAsFixed(2)}",
                              ),

                              const SizedBox(height: 10),

                              _SummaryRow(
                                title: "Discount",
                                value:
                                    "- ₹${orderState.discount.toStringAsFixed(2)}",
                              ),

                              const Divider(height: 30),

                              _SummaryRow(
                                title: "Grand Total",
                                value:
                                    "₹${orderState.grandTotal.toStringAsFixed(2)}",
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
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
