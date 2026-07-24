import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard_date_filter.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_appbar.dart';
import '../widgets/recent_order_tile.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: const DashboardAppBar(),

      body: dashboardState.when(
        // ============================================================
        // LOADING
        // ============================================================
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        // ============================================================
        // ERROR
        // ============================================================
        error: (error, stackTrace) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(dashboardProvider.notifier).refreshDashboard();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 150),

                const Icon(Icons.error_outline, size: 70, color: Colors.red),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "Unable to load dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(dashboardProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ),
              ],
            ),
          );
        },

        // ============================================================
        // SUCCESS
        // ============================================================
        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(dashboardProvider.notifier).refreshDashboard();
            },

            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good Morning 👋",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "Here's your business summary.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xff16A34A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            context.push("/orders/create");
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("New Order"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ==================================================
                    // DATE FILTER
                    // ==================================================
                    const DashboardDateFilterWidget(),
                    const SizedBox(height: 30),

                    // ==================================================
                    // SUMMARY - ROW 1
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Total Sales",
                            value:
                                "₹${dashboard.totalSales.toStringAsFixed(0)}",
                            color: const Color(0xff16A34A),
                            icon: Icons.currency_rupee,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: SummaryCard(
                            title: "Orders",
                            value: dashboard.totalOrders.toString(),
                            color: const Color(0xff2563EB),
                            icon: Icons.shopping_bag,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // SUMMARY - ROW 2
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Menu Items",
                            value: dashboard.totalMenuItems.toString(),
                            color: const Color(0xffF59E0B),
                            icon: Icons.restaurant_menu,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: SummaryCard(
                            title: "Pending",
                            value: dashboard.pendingOrders.toString(),
                            color: const Color(0xffDC2626),
                            icon: Icons.timer,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // RECENT ORDERS HEADER
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.push("/orders");
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(color: Color(0xff16A34A)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // RECENT ORDERS EMPTY STATE
                    // ==================================================
                    if (dashboard.recentOrders.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 60,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 70,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 20),

                            Text(
                              "No Orders Yet",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Create your first order to start selling.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    // ==================================================
                    // RECENT ORDERS LIST
                    // ==================================================
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
                              context.push("/orders");
                            },
                            child: RecentOrderTile(
                              orderNo: "#$shortOrderId",
                              customer:
                                  order.customerName ?? "Walk-in Customer",
                              amount: "₹${order.total.toStringAsFixed(0)}",
                              status: order.status,
                            ),
                          ),
                        );
                      }),

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
