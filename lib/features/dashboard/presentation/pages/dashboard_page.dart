import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_appbar.dart';
import '../widgets/dashboard_date_filter.dart';
import '../widgets/recent_order_tile.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ref.read(dashboardProvider.notifier).refreshDashboard();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          const SizedBox(height: 120),

          // ------------------------------------------------------
          // ERROR ICON
          // ------------------------------------------------------
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: Colors.red.shade600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Unable to load dashboard',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 10),

          Text(
            error.toString().replaceFirst('Exception: ', ''),
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: const Color(0xff64748B)),
          ),

          const SizedBox(height: 28),

          Center(
            child: FilledButton.icon(
              onPressed: () {
                ref.invalidate(dashboardProvider);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                'Retry',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY RECENT ORDERS
  // ============================================================

  Widget _buildEmptyOrders(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Column(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 34,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'No Orders Yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 8),

          Text(
            'Create your first order to start selling.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: const Color(0xff64748B)),
          ),

          const SizedBox(height: 22),

          // ------------------------------------------------------
          // CREATE FIRST ORDER
          // ------------------------------------------------------
          FilledButton.icon(
            onPressed: () {
              context.push('/orders/create');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              'Create Order',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: const DashboardAppBar(),

      body: dashboardState.when(
        // ========================================================
        // LOADING
        // ========================================================
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          );
        },

        // ========================================================
        // ERROR
        // ========================================================
        error: (error, stackTrace) {
          return _buildErrorState(context, ref, error);
        },

        // ========================================================
        // SUCCESS
        // ========================================================
        data: (dashboard) {
          return RefreshIndicator(
            color: AppColors.primary,

            onRefresh: () async {
              await ref.read(dashboardProvider.notifier).refreshDashboard();
            },

            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning 👋',
                                style: AppTextStyles.heading,
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Here's your business summary.",
                                style: AppTextStyles.body.copyWith(
                                  color: const Color(0xff64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ------------------------------------------
                        // NEW ORDER BUTTON
                        // ------------------------------------------
                        FilledButton.icon(
                          onPressed: () {
                            context.push('/orders/create');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: Text(
                            'New Order',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // DATE FILTER
                    // ==================================================
                    const DashboardDateFilterWidget(),

                    const SizedBox(height: 28),

                    // ==================================================
                    // SUMMARY ROW 1
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Total Sales',
                            value:
                                '₹${dashboard.totalSales.toStringAsFixed(0)}',
                            color: AppColors.primary,
                            icon: Icons.currency_rupee_rounded,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: SummaryCard(
                            title: 'Orders',
                            value: dashboard.totalOrders.toString(),
                            color: const Color(0xff2563EB),
                            icon: Icons.shopping_bag_outlined,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // SUMMARY ROW 2
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Menu Items',
                            value: dashboard.totalMenuItems.toString(),
                            color: const Color(0xffF59E0B),
                            icon: Icons.restaurant_menu_rounded,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: SummaryCard(
                            title: 'Pending',
                            value: dashboard.pendingOrders.toString(),
                            color: const Color(0xffDC2626),
                            icon: Icons.schedule_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ==================================================
                    // RECENT ORDERS HEADER
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Orders', style: AppTextStyles.title),

                        TextButton(
                          onPressed: () {
                            context.push('/orders');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'See All',
                                style: AppTextStyles.bodySemiBold.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(width: 3),

                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 13,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // RECENT ORDERS
                    // ==================================================
                    if (dashboard.recentOrders.isEmpty)
                      _buildEmptyOrders(context)
                    else
                      ...dashboard.recentOrders.map((order) {
                        final shortOrderId = order.id.length > 5
                            ? order.id
                                  .substring(order.id.length - 5)
                                  .toUpperCase()
                            : order.id.toUpperCase();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              context.push('/orders');
                            },
                            child: RecentOrderTile(
                              orderNo: '#$shortOrderId',
                              customer:
                                  order.customerName ?? 'Walk-in Customer',
                              amount: '₹${order.total.toStringAsFixed(0)}',
                              status: order.status,
                            ),
                          ),
                        );
                      }),

                    // Space for bottom navigation.
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
