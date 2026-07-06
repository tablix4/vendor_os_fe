import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/create_order_header.dart';
import '../widgets/create_order_search.dart';
import '../../../menu/presentation/providers/menu_provider.dart';
import '../../data/models/create_order_item.dart';
import '../../data/models/create_order_request.dart';
import '../providers/order_provider.dart';
import '../widgets/customer_info_section.dart';
import '../widgets/menu_item_selector_card.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/selected_order_item_card.dart';
import '../widgets/menu_section.dart';
import 'package:go_router/go_router.dart';

class CreateOrderPage extends ConsumerStatefulWidget {
  const CreateOrderPage({super.key});

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).clearCart();
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();

    final orderState = ref.read(orderProvider);

    if (orderState.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one menu item.")),
      );
      return;
    }

    final request = CreateOrderRequest(
      customerName: _customerNameController.text.trim().isEmpty
          ? null
          : _customerNameController.text.trim(),
      customerPhone: _customerPhoneController.text.trim().isEmpty
          ? null
          : _customerPhoneController.text.trim(),
      items: orderState.cart
          .map(
            (item) => CreateOrderItem(
              menuItemId: item.menuItem.id,
              quantity: item.quantity,
            ),
          )
          .toList(),
    );

    try {
      await ref.read(orderProvider.notifier).createOrder(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order created successfully.")),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      bottomNavigationBar: menuState.maybeWhen(
        data: (_) => OrderSummaryCard(
          loading: orderState.isCreatingOrder,
          onPlaceOrder: _placeOrder,
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: CreateOrderHeader(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CustomerInfoSection(
                    //   customerNameController: _customerNameController,
                    //   customerPhoneController: _customerPhoneController,
                    // ),
                    const SizedBox(height: 20),

                    CreateOrderSearch(
                      onChanged: (value) {
                        ref.read(menuProvider.notifier).search(value);
                      },
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Menu Items",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        menuState.maybeWhen(
                          data: (items) =>
                              Chip(label: Text("${items.length} Items")),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: menuState.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),

                        error: (error, _) {
                          return Center(child: Text(error.toString()));
                        },

                        data: (menuItems) {
                          return MenuSection(menuItems: menuItems);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (orderState.isCreatingOrder) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
