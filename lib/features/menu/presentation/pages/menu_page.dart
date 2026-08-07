import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../category/presentation/providers/category_provider.dart';

import '../providers/menu_provider.dart';

import '../widgets/add_menu_dialog.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_empty.dart';
import '../widgets/menu_filter_bar.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_search.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  final TextEditingController searchController = TextEditingController();

  String search = '';

  String? selectedCategoryId;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD MENU
  // ============================================================

  Future<void> _showAddMenuDialog() async {
    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AddMenuDialog();
      },
    );
  }

  // ============================================================
  // EDIT MENU
  // ============================================================

  Future<void> _showEditMenuDialog(dynamic menu) async {
    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AddMenuDialog(menu: menu);
      },
    );
  }

  // ============================================================
  // DELETE MENU
  // ============================================================

  Future<void> _showDeleteMenuDialog({
    required String menuId,
    required String menuName,
  }) async {
    FocusScope.of(context).unfocus();

    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --------------------------------------------------
              // DELETE ICON
              // --------------------------------------------------
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 32,
                  color: Colors.red.shade600,
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // TITLE
              // --------------------------------------------------
              Text(
                'Delete Menu Item?',
                textAlign: TextAlign.center,
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // DESCRIPTION
              // --------------------------------------------------
              Text(
                'Are you sure you want to delete "$menuName"?',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'This item will no longer appear in your active menu.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: const Color(0xff94A3B8),
                ),
              ),

              const SizedBox(height: 26),

              // --------------------------------------------------
              // ACTION BUTTONS
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff475569),
                        side: const BorderSide(color: Color(0xffE2E8F0)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.button.copyWith(
                          color: const Color(0xff475569),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    try {
      await ref.read(menuProvider.notifier).deleteMenu(menuId);

      if (!mounted) return;

      _showSuccessMessage('Menu item deleted successfully.');
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ============================================================
  // TOGGLE AVAILABILITY
  // ============================================================

  Future<void> _toggleAvailability(String menuId) async {
    try {
      await ref.read(menuProvider.notifier).toggleAvailability(menuId);
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  void _clearFilters() {
    FocusScope.of(context).unfocus();

    searchController.clear();

    setState(() {
      search = '';
      selectedCategoryId = null;
    });
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(Object error) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ref.read(menuProvider.notifier).refresh();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 130),

          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red.shade600,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Unable to load menu',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 10),

          Text(
            error.toString().replaceFirst('Exception: ', ''),
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: const Color(0xff64748B)),
          ),

          const SizedBox(height: 26),

          Center(
            child: FilledButton.icon(
              onPressed: () {
                ref.invalidate(menuProvider);
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
  // NO FILTER RESULTS
  // ============================================================

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: Color(0xffF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: Color(0xff64748B),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'No menu items found',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),

          const SizedBox(height: 8),

          Text(
            'No menu items match your current search or category filter.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: const Color(0xff64748B)),
          ),

          const SizedBox(height: 20),

          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
            label: Text(
              'Clear Filters',
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.primary,
              ),
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
  Widget build(BuildContext context) {
    final menus = ref.watch(menuProvider);

    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: const Color(0xffF8FAFC),
        titleSpacing: 20,
        title: Text(
          'Menu Management',
          style: AppTextStyles.heading.copyWith(fontSize: 24),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: menus.when(
        // ======================================================
        // LOADING
        // ======================================================
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          );
        },

        // ======================================================
        // ERROR
        // ======================================================
        error: (error, stackTrace) {
          return _buildErrorState(error);
        },

        // ======================================================
        // DATA
        // ======================================================
        data: (items) {
          final normalizedSearch = search.trim().toLowerCase();

          final filteredMenus = items.where((menu) {
            final searchMatch =
                normalizedSearch.isEmpty ||
                menu.name.toLowerCase().contains(normalizedSearch);

            final categoryMatch =
                selectedCategoryId == null ||
                menu.categoryId == selectedCategoryId;

            return searchMatch && categoryMatch;
          }).toList();

          final availableItems = items.where((menu) => menu.isAvailable).length;

          final unavailableItems = items
              .where((menu) => !menu.isAvailable)
              .length;

          final hasActiveFilter =
              normalizedSearch.isNotEmpty || selectedCategoryId != null;

          return RefreshIndicator(
            color: AppColors.primary,

            onRefresh: () async {
              await ref.read(menuProvider.notifier).refresh();
            },

            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                // ==================================================
                // HEADER
                // ==================================================
                MenuHeader(
                  totalItems: items.length,
                  availableItems: availableItems,
                  unavailableItems: unavailableItems,
                  onAdd: _showAddMenuDialog,
                ),

                // ==================================================
                // SEARCH
                // ==================================================
                MenuSearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                // ==================================================
                // CATEGORY FILTER
                // ==================================================
                categories.when(
                  loading: () {
                    return const SizedBox.shrink();
                  },
                  error: (_, __) {
                    return const SizedBox.shrink();
                  },
                  data: (list) {
                    return MenuFilterBar(
                      categories: list,
                      selectedCategoryId: selectedCategoryId,
                      onCategorySelected: (id) {
                        FocusScope.of(context).unfocus();

                        setState(() {
                          selectedCategoryId = id;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 22),

                // ==================================================
                // DATABASE IS EMPTY
                // ==================================================
                if (items.isEmpty)
                  SizedBox(
                    height: 400,
                    child: MenuEmpty(onAdd: _showAddMenuDialog),
                  )
                // ==================================================
                // FILTER/SEARCH HAS NO RESULT
                // ==================================================
                else if (filteredMenus.isEmpty && hasActiveFilter)
                  _buildNoResults()
                // ==================================================
                // MENU LIST
                // ==================================================
                else
                  ...filteredMenus.map((menu) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: MenuCard(
                        menu: menu,

                        // ------------------------------------------
                        // EDIT
                        // ------------------------------------------
                        onEdit: () {
                          _showEditMenuDialog(menu);
                        },

                        // ------------------------------------------
                        // DELETE
                        // ------------------------------------------
                        onDelete: () {
                          _showDeleteMenuDialog(
                            menuId: menu.id,
                            menuName: menu.name,
                          );
                        },

                        // ------------------------------------------
                        // AVAILABILITY
                        // ------------------------------------------
                        onAvailabilityChanged: (_) {
                          _toggleAvailability(menu.id);
                        },
                      ),
                    );
                  }),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),

      // ========================================================
      // ADD MENU BUTTON
      // ========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMenuDialog,
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'Add Menu',
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
