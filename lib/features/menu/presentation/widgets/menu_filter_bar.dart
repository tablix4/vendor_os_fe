import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../category/data/models/category_model.dart';

import 'category_chip.dart';

class MenuFilterBar extends StatelessWidget {
  final List<CategoryModel> categories;

  final String? selectedCategoryId;

  final ValueChanged<String?> onCategorySelected;

  const MenuFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // No categories available yet.
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // FILTER HEADER
        // ======================================================
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Row(
        // children: [
        // --------------------------------------------------
        // FILTER ICON
        // --------------------------------------------------
        // Container(
        //   width: 34,
        //   height: 34,
        //   decoration: BoxDecoration(
        //     color: AppColors.primary.withValues(alpha: 0.08),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: const Icon(
        //     Icons.tune_rounded,
        //     size: 18,
        //     color: AppColors.primary,
        //   ),
        // ),

        // const SizedBox(width: 10),

        // --------------------------------------------------
        // TITLE
        // --------------------------------------------------
        // Expanded(
        //   child: Text(
        //     'Filter by Category',
        //     style: AppTextStyles.bodySemiBold.copyWith(
        //       color: const Color(0xff334155),
        //     ),
        //   ),
        // ),

        // --------------------------------------------------
        // CLEAR FILTER
        // --------------------------------------------------
        // if (selectedCategoryId != null)
        // TextButton(
        //   onPressed: () {
        //     onCategorySelected(null);
        //   },
        //   style: TextButton.styleFrom(
        //     foregroundColor: AppColors.primary,
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: 8,
        //       vertical: 4,
        //     ),
        //     minimumSize: Size.zero,
        //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //   ),
        //   child: Text(
        //     'Clear',
        //     style: AppTextStyles.small.copyWith(
        //       color: AppColors.primary,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        // ],
        //   ),
        // ),
        // const SizedBox(height: 12),

        // ======================================================
        // CATEGORY CHIPS
        // ======================================================
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 6),
            children: [
              // ==================================================
              // ALL
              // ==================================================
              CategoryChip(
                title: 'All',
                selected: selectedCategoryId == null,
                onTap: () {
                  onCategorySelected(null);
                },
              ),

              // ==================================================
              // CATEGORIES
              // ==================================================
              ...categories.map((category) {
                return CategoryChip(
                  title: category.name,
                  selected: selectedCategoryId == category.id,
                  onTap: () {
                    onCategorySelected(category.id);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY CATEGORY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Add categories to organize and filter your menu.',
              style: AppTextStyles.small.copyWith(
                color: const Color(0xff64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
