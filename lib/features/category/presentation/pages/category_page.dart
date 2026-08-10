import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../providers/category_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/category_header.dart';
import '../widgets/category_search.dart';
import '../widgets/empty_category.dart';
import '../widgets/slidable_category_card.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final TextEditingController searchController = TextEditingController();

  String search = '';

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<void> _showAddCategoryDialog() async {
    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AddCategoryDialog(
          onSave: (name) {
            return ref.read(categoryProvider.notifier).createCategory(name);
          },
        );
      },
    );
  }

  // ============================================================
  // EDIT CATEGORY
  // ============================================================

  Future<void> _showEditCategoryDialog({
    required String categoryId,
    required String categoryName,
  }) async {
    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AddCategoryDialog(
          initialValue: categoryName,
          title: 'Update Category',
          buttonText: 'Update',
          onSave: (name) {
            return ref
                .read(categoryProvider.notifier)
                .updateCategory(categoryId, name);
          },
        );
      },
    );
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<void> _showDeleteCategoryDialog({
    required String categoryId,
    required String categoryName,
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
                'Delete Category?',
                textAlign: TextAlign.center,
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // DESCRIPTION
              // --------------------------------------------------
              Text(
                'Are you sure you want to delete "$categoryName"?',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: const Color(0xff94A3B8),
                ),
              ),

              const SizedBox(height: 26),

              // --------------------------------------------------
              // ACTIONS
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
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
                        Navigator.pop(dialogContext, true);
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
      await ref.read(categoryProvider.notifier).deleteCategory(categoryId);

      if (!mounted) return;

      _showSuccessMessage('Category deleted successfully.');
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    }
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
        await ref.read(categoryProvider.notifier).getCategories();
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
            'Unable to load categories',
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
                ref.invalidate(categoryProvider);
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
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final totalCategories = categories.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

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

        title: Row(
          children: [
            Expanded(
              child: Text(
                'Categories',
                style: AppTextStyles.heading.copyWith(fontSize: 24),
              ),
            ),

            // const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$totalCategories',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 10),

            SizedBox(
              height: 42,
              child: FilledButton(
                onPressed: _showAddCategoryDialog,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, size: 19),

                    const SizedBox(width: 5),

                    Text(
                      'New',
                      style: AppTextStyles.button.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: categories.when(
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

          final filtered = normalizedSearch.isEmpty
              ? items
              : items.where((category) {
                  return category.name.toLowerCase().contains(normalizedSearch);
                }).toList();

          return RefreshIndicator(
            color: AppColors.primary,

            onRefresh: () async {
              await ref.read(categoryProvider.notifier).getCategories();
            },

            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.only(bottom: 120),

              children: [
                // ==================================================
                // CATEGORY HEADER
                // ==================================================
                // CategoryHeader(
                //   totalCategories: items.length,
                //   onAdd: _showAddCategoryDialog,
                // ),

                // ==================================================
                // SEARCH
                // ==================================================
                CategorySearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // EMPTY DATABASE
                // ==================================================
                if (items.isEmpty)
                  SizedBox(
                    height: 400,
                    child: EmptyCategory(onAdd: _showAddCategoryDialog),
                  )
                // ==================================================
                // NO SEARCH RESULTS
                // ==================================================
                else if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xffF1F5F9),
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
                          'No categories found',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitle,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'No category matches "$search". Try another search.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: const Color(0xff64748B),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton.icon(
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              search = '';
                            });
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: Text(
                            'Clear Search',
                            style: AppTextStyles.bodySemiBold,
                          ),
                        ),
                      ],
                    ),
                  )
                // ==================================================
                // CATEGORY LIST
                // ==================================================
                else
                  ...filtered.map((category) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SlidableCategoryCard(
                        category: category,

                        onEdit: () {
                          _showEditCategoryDialog(
                            categoryId: category.id,
                            categoryName: category.name,
                          );
                        },

                        onDelete: () {
                          _showDeleteCategoryDialog(
                            categoryId: category.id,
                            categoryName: category.name,
                          );
                        },
                      ),
                    );
                  }),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),

      // ========================================================
      // ADD CATEGORY BUTTON
      // ========================================================
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _showAddCategoryDialog,

      //   elevation: 2,
      //   highlightElevation: 4,

      //   backgroundColor: AppColors.primary,
      //   foregroundColor: Colors.white,

      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      //   icon: const Icon(Icons.add_rounded, size: 22),

      //   label: Text(
      //     'Add Category',
      //     style: AppTextStyles.button.copyWith(color: Colors.white),
      //   ),
      // ),
    );
  }
}
