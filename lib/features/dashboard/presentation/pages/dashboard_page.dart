import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../order/presentation/providers/order_provider.dart';

import '../widgets/dashboard_appbar.dart';
import '../widgets/recent_order_tile.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: const DashboardAppBar(),

      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(orderProvider.notifier).refresh();
        },

        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //------------------------------------------------------------
                // Header
                //------------------------------------------------------------
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

                const SizedBox(height: 30),

                //------------------------------------------------------------
                // Summary Cards
                //------------------------------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Today's Sales",
                        value: "₹4,250",
                        color: const Color(0xff16A34A),
                        icon: Icons.currency_rupee,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: SummaryCard(
                        title: "Orders",
                        value: orderState.orders.length.toString(),
                        color: const Color(0xff2563EB),
                        icon: Icons.shopping_bag,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    const Expanded(
                      child: SummaryCard(
                        title: "Menu Items",
                        value: "24",
                        color: Color(0xffF59E0B),
                        icon: Icons.restaurant_menu,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: SummaryCard(
                        title: "Pending",
                        value: orderState.orders
                            .where((e) => e.status.name == "pending")
                            .length
                            .toString(),
                        color: const Color(0xffDC2626),
                        icon: Icons.timer,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                //------------------------------------------------------------
                // Recent Orders Header
                //------------------------------------------------------------
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
                        style: TextStyle(
                        color: Color(0xff16A34A),
                      ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //------------------------------------------------------------
                // Recent Orders
                //------------------------------------------------------------
                if (orderState.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (orderState.orders.isEmpty)
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
                        Icon(Icons.receipt_long, size: 70, color: Colors.grey),
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
                else
                  ...orderState.orders.take(10).map((order) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          context.push("/orders");
                        },
                        child: RecentOrderTile(
                          orderNo:
                              "#${order.id.substring(order.id.length - 5).toUpperCase()}",
                          customer: order.customerName ?? "Walk-in Customer",
                          amount: "₹${order.total.toStringAsFixed(0)}",
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
