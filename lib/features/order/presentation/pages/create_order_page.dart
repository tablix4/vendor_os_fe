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

  // ============================================================
  // SEARCH FOCUS
  // ============================================================

  final FocusNode _searchFocusNode = FocusNode();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Listen for search focus.
    //
    // As soon as user taps the search field,
    // collapse the expanded order summary.
    _searchFocusNode.addListener(_handleSearchFocus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(orderProvider.notifier).clearCart();
    });
  }

  // ============================================================
  // SEARCH FOCUS HANDLER
  // ============================================================

  void _handleSearchFocus() {
    if (!_searchFocusNode.hasFocus) {
      return;
    }

    if (_isOrderSummaryExpanded) {
      setState(() {
        _isOrderSummaryExpanded = false;
      });
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchFocusNode.removeListener(_handleSearchFocus);

    _searchFocusNode.dispose();

    _customerNameController.dispose();
    _customerPhoneController.dispose();

    super.dispose();
  }

  // ============================================================
  // FRONTEND SEARCH
  // ============================================================

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();

      // Extra protection:
      // If summary somehow remains expanded while typing,
      // collapse it immediately.
      if (_isOrderSummaryExpanded) {
        _isOrderSummaryExpanded = false;
      }
    });
  }

  // ============================================================
  // CALCULATE ORDER TOTAL
  // ============================================================

  double _calculateTotal(orderState) {
    double total = 0;

    for (final item in orderState.cart) {
      total += item.menuItem.price * item.quantity;
    }

    return total;
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toStringAsFixed(0);
    }

    return amount.toStringAsFixed(2);
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> _placeOrder() async {
    // Close keyboard before creating the order.
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
        const SnackBar(
          content: Text('Order created successfully.'),
          backgroundColor: Color(0xff16A34A),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    final orderState = ref.watch(orderProvider);

    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    final total = _calculateTotal(orderState);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      // IMPORTANT:
      // Allow the page to resize when keyboard appears.
      resizeToAvoidBottomInset: true,

      // ========================================================
      // ORDER SUMMARY + PLACE ORDER
      // ========================================================
      bottomNavigationBar: menuState.maybeWhen(
        data: (_) {
          return SafeArea(
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xffE2E8F0))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // ORDER SUMMARY
                  // ==================================================
                  OrderSummaryCard(
                    loading: orderState.isCreatingOrder,

                    // Never allow expanded content while keyboard
                    // is visible.
                    isExpanded: _isOrderSummaryExpanded && !keyboardOpen,

                    onToggle: () {
                      // If keyboard is open, close it before
                      // expanding the summary.
                      if (keyboardOpen) {
                        FocusScope.of(context).unfocus();
                      }

                      setState(() {
                        _isOrderSummaryExpanded = !_isOrderSummaryExpanded;
                      });
                    },
                  ),

                  // ==================================================
                  // PLACE ORDER BUTTON
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            orderState.cart.isEmpty ||
                                orderState.isCreatingOrder
                            ? null
                            : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff16A34A),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xffE2E8F0),
                          disabledForegroundColor: const Color(0xff94A3B8),
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
                            : Text(
                                // 'Place Order (₹${_formatAmount(total)})',
                                'Place Order',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: CreateOrderHeader(),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // SEARCH
            // ==================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CreateOrderSearch(
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
              ),
            ),

            // Use less spacing while keyboard is open.
            SizedBox(height: keyboardOpen ? 12 : 24),

            // ==================================================
            // MENU TITLE
            // ==================================================
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

            SizedBox(height: keyboardOpen ? 8 : 16),

            // ==================================================
            // MENU LIST
            // ==================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: menuState.when(
                  // --------------------------------------------
                  // LOADING
                  // --------------------------------------------
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },

                  // --------------------------------------------
                  // ERROR
                  // --------------------------------------------
                  error: (error, _) {
                    return Center(child: Text(error.toString()));
                  },

                  // --------------------------------------------
                  // DATA
                  // --------------------------------------------
                  data: (menuItems) {
                    // Search locally.
                    // No API request is made when typing.

                    final filteredMenuItems = _searchQuery.isEmpty
                        ? menuItems
                        : menuItems.where((item) {
                            final name = item.name.toLowerCase();

                            return name.contains(_searchQuery);
                          }).toList();

                    // ------------------------------------------
                    // EMPTY STATE
                    // ------------------------------------------

                    if (filteredMenuItems.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 44,
                                color: Color(0xff94A3B8),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                _searchQuery.isEmpty
                                    ? 'No menu items available'
                                    : 'No menu items found',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ------------------------------------------
                    // MENU
                    // ------------------------------------------

                    return MenuSection(menuItems: filteredMenuItems);
                  },
                ),
              ),
            ),

            // ==================================================
            // CREATE ORDER LOADING
            // ==================================================
            if (orderState.isCreatingOrder) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
