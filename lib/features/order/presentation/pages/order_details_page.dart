import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/order_status.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

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

  // ============================================================
  // LOAD DETAILS
  // ============================================================

  Future<OrderModel> _loadDetails() {
    return ref.read(orderProvider.notifier).getOrderDetails(widget.orderId);
  }

  // ============================================================
  // CANCEL ORDER
  // ============================================================

  Future<void> _cancelOrder(OrderModel order) async {
    final confirmed = await showDialog<bool>(
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
          content: const Text(
            'Are you sure you want to cancel this order? '
            'This action cannot be undone.',
          ),
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

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(orderProvider.notifier).cancelOrder(order.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _detailsFuture = _loadDetails();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled successfully')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to cancel order')));
    }
  }

  // ============================================================
  // REFRESH ORDER
  // ============================================================

  Future<void> _refreshOrder() async {
    final updated = await _loadDetails();

    if (!mounted) {
      return;
    }

    setState(() {
      _detailsFuture = Future<OrderModel>.value(updated);
    });
  }

  // ============================================================
  // CALCULATE SUBTOTAL
  // ============================================================

  double _calculateSubtotal(OrderModel order) {
    return order.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // ============================================================
  // MARK AS COMPLETED
  // ============================================================

  Future<void> _markAsCompleted(OrderModel order) async {
    try {
      await ref
          .read(orderProvider.notifier)
          .updateOrderStatus(
            orderId: order.id,
            status: OrderStatus.completed.apiValue,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _detailsFuture = _loadDetails();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: Text('Order marked as completed')),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSpacing.lg),
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Unable to update order status. '
                  'Please try again.',
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
        ),

        title: Text(
          'Order Details',
          style: AppTextStyles.subtitle.copyWith(fontSize: 19),
        ),

        centerTitle: false,
      ),

      body: FutureBuilder<OrderModel>(
        future: _detailsFuture,

        builder: (context, snapshot) {
          // ------------------------------------------------------
          // LOADING
          // ------------------------------------------------------

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const _OrderDetailsLoading();
          }

          // ------------------------------------------------------
          // ERROR
          // ------------------------------------------------------

          if (snapshot.hasError) {
            return _OrderDetailsError(
              onRetry: () {
                setState(() {
                  _detailsFuture = _loadDetails();
                });
              },
            );
          }

          // ------------------------------------------------------
          // ORDER
          // ------------------------------------------------------

          final order = snapshot.data;

          if (order == null) {
            return const _OrderNotFound();
          }

          return _OrderDetailsContent(
            order: order,

            isUpdating: ref.watch(
              orderProvider.select(
                (state) => state.updatingOrderId == order.id,
              ),
            ),

            onRefresh: _refreshOrder,

            onMarkCompleted: () {
              _markAsCompleted(order);
            },

            onCancel: () {
              _cancelOrder(order);
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// MAIN CONTENT
// ============================================================

class _OrderDetailsContent extends StatelessWidget {
  final OrderModel order;

  final bool isUpdating;

  final Future<void> Function() onRefresh;

  final VoidCallback onMarkCompleted;

  final VoidCallback onCancel;

  const _OrderDetailsContent({
    required this.order,
    required this.isUpdating,
    required this.onRefresh,
    required this.onMarkCompleted,
    required this.onCancel,
  });

  // ============================================================
  // SUBTOTAL
  // ============================================================

  double _calculateSubtotal() {
    return order.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();

    // Backend total is the source of truth.
    final grandTotal = order.total;

    // ----------------------------------------------------------
    // STATUS RULES
    // ----------------------------------------------------------

    final canCancel =
        order.status == OrderStatus.pending ||
        order.status == OrderStatus.accepted;

    final canMarkDone =
        order.status == OrderStatus.pending ||
        order.status == OrderStatus.accepted ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.ready;

    // ----------------------------------------------------------
    // CUSTOMER
    // ----------------------------------------------------------

    final customerName = order.customerName?.trim().isNotEmpty == true
        ? order.customerName!.trim()
        : 'Walk-in Customer';

    // ----------------------------------------------------------
    // DATE
    // ----------------------------------------------------------

    final formattedDate = DateFormat('dd MMM yyyy').format(order.createdAt);

    final formattedTime = DateFormat('hh:mm a').format(order.createdAt);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          120,
        ),

        children: [
          // ==================================================
          // ORDER HERO
          // ==================================================
          _OrderHeroCard(
            order: order,
            customerName: customerName,
            formattedDate: formattedDate,
            formattedTime: formattedTime,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ==================================================
          // CUSTOMER
          // ==================================================
          const _SectionHeader(
            title: 'Customer',
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: AppSpacing.sm),

          _CustomerCard(
            customerName: customerName,
            customerPhone: order.customerPhone,
          ),

          const SizedBox(height: AppSpacing.xl),

          // ==================================================
          // ORDER ITEMS
          // ==================================================
          _SectionHeader(
            title: 'Order Items',
            icon: Icons.restaurant_menu_rounded,
            trailing: '${order.items.length} items',
          ),

          const SizedBox(height: AppSpacing.sm),

          if (order.items.isEmpty)
            const _EmptyItemsCard()
          else
            ...order.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == order.items.length - 1 ? 0 : AppSpacing.sm,
                ),
                child: _OrderItemCard(item: item, index: index),
              );
            }),

          const SizedBox(height: AppSpacing.xl),

          // ==================================================
          // BILL SUMMARY
          // ==================================================
          const _SectionHeader(
            title: 'Bill Summary',
            icon: Icons.receipt_long_outlined,
          ),

          const SizedBox(height: AppSpacing.sm),

          _BillSummaryCard(subtotal: subtotal, grandTotal: grandTotal),

          const SizedBox(height: AppSpacing.xl),

          // ==================================================
          // STATUS / ACTION
          // ==================================================
          if (order.status == OrderStatus.cancelled)
            const _CancelledCard()
          else if (canCancel)
            Row(
              children: [
                // ------------------------------------------
                // COMPLETE
                // ------------------------------------------
                Expanded(
                  child: _CompleteOrderButton(
                    isUpdating: isUpdating,
                    onPressed: onMarkCompleted,
                  ),
                ),

                const SizedBox(width: 10),

                // ------------------------------------------
                // CANCEL
                // ------------------------------------------
                Expanded(
                  child: _CancelOrderButton(
                    isUpdating: isUpdating,
                    onPressed: onCancel,
                  ),
                ),
              ],
            )
          else if (canMarkDone)
            _CompleteOrderButton(
              isUpdating: isUpdating,
              onPressed: onMarkCompleted,
            )
          else
            const _CompletedCard(),

          const SizedBox(height: AppSpacing.lg),

          // ==================================================
          // FOOTER
          // ==================================================
          Center(
            child: Text(
              'Order ID • ${order.id}',
              textAlign: TextAlign.center,
              style: AppTextStyles.small.copyWith(color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ORDER HERO CARD
// ============================================================

class _OrderHeroCard extends StatelessWidget {
  final OrderModel order;

  final String customerName;

  final String formattedDate;

  final String formattedTime;

  const _OrderHeroCard({
    required this.order,
    required this.customerName,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.black, Color(0xff1E293B)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // HERO HEADER
          // ==================================================
          Row(
            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),

                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),

              const Spacer(),

              _HeroStatus(status: order.status),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ==================================================
          // TOTAL
          // ==================================================
          Text(
            'Total Amount',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            '₹${order.total.toStringAsFixed(2)}',
            style: AppTextStyles.display.copyWith(
              fontSize: 34,
              color: AppColors.white,
              height: 1.1,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),

          const SizedBox(height: AppSpacing.md),

          // ==================================================
          // CUSTOMER + TIME
          // ==================================================
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 17,
                color: Colors.white70,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              const Icon(
                Icons.schedule_rounded,
                size: 17,
                color: Colors.white70,
              ),

              const SizedBox(width: 6),

              Text(
                formattedTime,
                style: AppTextStyles.small.copyWith(color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          Padding(
            padding: const EdgeInsets.only(left: 23),
            child: Text(
              formattedDate,
              style: AppTextStyles.small.copyWith(
                color: Colors.white.withValues(alpha: 0.60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HERO STATUS
// ============================================================

class _HeroStatus extends StatelessWidget {
  final OrderStatus status;

  const _HeroStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = status == OrderStatus.cancelled;

    final bool isPending = status == OrderStatus.pending;

    final Color foregroundColor;

    if (isCancelled) {
      foregroundColor = const Color(0xffF87171);
    } else if (isPending) {
      foregroundColor = const Color(0xffFBBF24);
    } else {
      foregroundColor = const Color(0xff4ADE80);
    }

    final backgroundColor = foregroundColor.withValues(alpha: 0.16);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.25)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(
              color: foregroundColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            status.displayName,
            style: AppTextStyles.small.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CUSTOMER CARD
// ============================================================

class _CustomerCard extends StatelessWidget {
  final String customerName;

  final String? customerPhone;

  const _CustomerCard({
    required this.customerName,
    required this.customerPhone,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhone = customerPhone?.trim().isNotEmpty == true;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySemiBold,
                ),

                const SizedBox(height: 4),

                Text(
                  hasPhone ? customerPhone! : 'Walk-in order',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          if (hasPhone)
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),

              child: IconButton(
                tooltip: 'Call customer',
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Phone action can be connected later.
                },
                icon: const Icon(
                  Icons.phone_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION HEADER
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  final IconData icon;

  final String? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),

          child: Icon(icon, color: AppColors.primary, size: 18),
        ),

        const SizedBox(width: AppSpacing.sm),

        Text(title, style: AppTextStyles.subtitle.copyWith(fontSize: 17)),

        if (trailing != null) ...[
          const Spacer(),

          Text(
            trailing!,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// ORDER ITEM CARD
// ============================================================

class _OrderItemCard extends StatelessWidget {
  final dynamic item;

  final int index;

  const _OrderItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final itemTotal = item.price * item.quantity;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // ==================================================
          // ITEM NUMBER
          // ==================================================
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),

            alignment: Alignment.center,

            child: Text(
              '${index + 1}',
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ==================================================
          // ITEM DETAILS
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySemiBold,
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: AppTextStyles.caption,
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Qty ${item.quantity}',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ==================================================
          // TOTAL
          // ==================================================
          Text(
            '₹${itemTotal.toStringAsFixed(2)}',
            style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMPTY ITEMS
// ============================================================

class _EmptyItemsCard extends StatelessWidget {
  const _EmptyItemsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 38,
            color: AppColors.grey.withValues(alpha: 0.60),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text('No items found', style: AppTextStyles.bodySemiBold),

          const SizedBox(height: 4),

          Text(
            'This order does not contain any items.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BILL SUMMARY
// ============================================================

class _BillSummaryCard extends StatelessWidget {
  final double subtotal;

  final double grandTotal;

  const _BillSummaryCard({required this.subtotal, required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        children: [
          _BillRow(label: 'Subtotal', value: '₹${subtotal.toStringAsFixed(2)}'),

          const SizedBox(height: AppSpacing.md),

          const _BillRow(label: 'Tax', value: '₹0.00'),

          const SizedBox(height: AppSpacing.md),

          const _BillRow(label: 'Discount', value: '₹0.00'),

          const SizedBox(height: AppSpacing.lg),

          Divider(height: 1, color: AppColors.border),

          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),

            child: Row(
              children: [
                Text(
                  'Grand Total',
                  style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16),
                ),

                const Spacer(),

                Text(
                  '₹${grandTotal.toStringAsFixed(2)}',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BILL ROW
// ============================================================

class _BillRow extends StatelessWidget {
  final String label;

  final String value;

  const _BillRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: AppColors.grey)),

        const Spacer(),

        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}

// ============================================================
// COMPLETE ORDER BUTTON
// ============================================================

class _CompleteOrderButton extends StatelessWidget {
  final bool isUpdating;

  final VoidCallback onPressed;

  const _CompleteOrderButton({
    required this.isUpdating,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),

      decoration: BoxDecoration(
        // color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        // border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),

      child: FilledButton.icon(
        onPressed: isUpdating ? null : onPressed,

        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),

          backgroundColor: AppColors.primary,

          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.55),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),

        icon: isUpdating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_circle_outline_rounded),

        label: Text(
          isUpdating ? 'Updating Order...' : 'Mark as Completed',

          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

// ============================================================
// CANCEL ORDER BUTTON
// ============================================================

class _CancelOrderButton extends StatelessWidget {
  final bool isUpdating;

  final VoidCallback onPressed;

  const _CancelOrderButton({required this.isUpdating, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isUpdating ? null : onPressed,

      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),

        foregroundColor: const Color(0xFFDC2626),

        disabledForegroundColor: const Color(0xFF9CA3AF),

        side: const BorderSide(color: Color(0xFFFCA5A5)),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      icon: const Icon(Icons.close_rounded),

      label: const Text('Cancel Order'),
    );
  }
}

// ============================================================
// COMPLETED CARD
// ============================================================

class _CompletedCard extends StatelessWidget {
  const _CompletedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Completed',
                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'This order has already been completed.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CANCELLED CARD
// ============================================================

class _CancelledCard extends StatelessWidget {
  const _CancelledCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),

        borderRadius: BorderRadius.circular(AppRadius.lg),

        border: Border.all(color: const Color(0xFFFECACA)),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Cancelled',
                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: const Color(0xFFB91C1C),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'This order has been cancelled and cannot be updated.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOADING STATE
// ============================================================

class _OrderDetailsLoading extends StatelessWidget {
  const _OrderDetailsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.all(AppSpacing.lg),

      children: [
        _SkeletonBox(height: 230, radius: AppRadius.xl),

        const SizedBox(height: AppSpacing.xl),

        const _SkeletonLine(width: 130),

        const SizedBox(height: AppSpacing.sm),

        _SkeletonBox(height: 82, radius: AppRadius.md),

        const SizedBox(height: AppSpacing.xl),

        const _SkeletonLine(width: 150),

        const SizedBox(height: AppSpacing.sm),

        _SkeletonBox(height: 80, radius: AppRadius.md),

        const SizedBox(height: AppSpacing.sm),

        _SkeletonBox(height: 80, radius: AppRadius.md),

        const SizedBox(height: AppSpacing.xl),

        _SkeletonBox(height: 190, radius: AppRadius.lg),
      ],
    );
  }
}

// ============================================================
// SKELETON BOX
// ============================================================

class _SkeletonBox extends StatelessWidget {
  final double height;

  final double radius;

  const _SkeletonBox({required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,

      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ============================================================
// SKELETON LINE
// ============================================================

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 18,

      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ============================================================
// ERROR STATE
// ============================================================

class _OrderDetailsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _OrderDetailsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cloud_off_rounded,
                size: 38,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Unable to load order',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Something went wrong while loading the order details.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.grey),
            ),

            const SizedBox(height: AppSpacing.xl),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NOT FOUND
// ============================================================

class _OrderNotFound extends StatelessWidget {
  const _OrderNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.receipt_long_outlined,
                size: 38,
                color: AppColors.grey,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text('Order not found', style: AppTextStyles.subtitle),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'The order may have been removed or is no longer available.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
