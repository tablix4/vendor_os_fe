import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../menu/presentation/providers/menu_provider.dart';

import '../../data/models/create_order_item.dart';
import '../../data/models/create_order_request.dart';

import '../providers/order_provider.dart';

import '../widgets/create_order_header.dart';
import '../widgets/create_order_search.dart';
import '../widgets/menu_section.dart';
import '../widgets/order_summary_card.dart';

class CreateOrderPage extends ConsumerStatefulWidget {
  const CreateOrderPage({super.key});

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  bool _isOrderSummaryExpanded = false;

  String _searchQuery = '';

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
        const SnackBar(content: Text('Please select at least one menu item.')),
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
        const SnackBar(content: Text('Order created successfully.')),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ------------------------------------------------------------
  // FRONTEND SEARCH
  // ------------------------------------------------------------

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      // ----------------------------------------------------------
      // ORDER SUMMARY
      // ----------------------------------------------------------
      bottomNavigationBar: menuState.maybeWhen(
        data: (_) => SafeArea(
          top: false,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ------------------------------------------------------
                // EXISTING EXPANDABLE ORDER SUMMARY
                // ------------------------------------------------------
                OrderSummaryCard(
                  loading: orderState.isCreatingOrder,
                  isExpanded: _isOrderSummaryExpanded,
                  onToggle: () {
                    setState(() {
                      _isOrderSummaryExpanded = !_isOrderSummaryExpanded;
                    });
                  },
                ),

                // ------------------------------------------------------
                // PLACE ORDER BUTTON - ALWAYS VISIBLE
                // ------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          orderState.cart.isEmpty || orderState.isCreatingOrder
                          ? null
                          : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff16A34A),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: orderState.isCreatingOrder
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // HEADER
            // ----------------------------------------------------
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: CreateOrderHeader(),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // SEARCH
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CreateOrderSearch(onChanged: _onSearchChanged),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // MENU TITLE
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu Items',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  menuState.maybeWhen(
                    data: (items) {
                      final filteredItems = _searchQuery.isEmpty
                          ? items
                          : items.where((item) {
                              final name = item.name.toLowerCase();

                              return name.contains(_searchQuery);
                            }).toList();

                      return Chip(label: Text('${filteredItems.length} Items'));
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ----------------------------------------------------
            // MENU
            // ----------------------------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: menuState.when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },

                  error: (error, _) {
                    return Center(child: Text(error.toString()));
                  },

                  data: (menuItems) {
                    // --------------------------------------------
                    // LOCAL SEARCH
                    // No API request is made here.
                    // --------------------------------------------

                    final filteredMenuItems = _searchQuery.isEmpty
                        ? menuItems
                        : menuItems.where((item) {
                            final name = item.name.toLowerCase();

                            return name.contains(_searchQuery);
                          }).toList();

                    // --------------------------------------------
                    // EMPTY SEARCH RESULT
                    // --------------------------------------------

                    if (filteredMenuItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Colors.grey,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              _searchQuery.isEmpty
                                  ? 'No menu items available'
                                  : 'No menu items found',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return MenuSection(menuItems: filteredMenuItems);
                  },
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
