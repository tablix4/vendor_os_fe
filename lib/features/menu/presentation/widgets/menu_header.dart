import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MenuHeader extends StatelessWidget {
  final int totalItems;
  final int availableItems;
  final int unavailableItems;
  final VoidCallback onAdd;

  const MenuHeader({
    super.key,
    required this.totalItems,
    required this.availableItems,
    required this.unavailableItems,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(0),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        // gradient: const LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [AppColors.primary, Color(0xff0F766E)],
        // ),

        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primary.withValues(alpha: 0.18),
        //     blurRadius: 22,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // HEADER ICON
          // ====================================================
          // Container(
          //   width: 46,
          //   height: 46,

          //   decoration: BoxDecoration(
          //     color: Colors.white.withValues(alpha: 0.16),
          //     borderRadius: BorderRadius.circular(14),
          //   ),

          //   child: const Icon(
          //     Icons.restaurant_menu_rounded,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          // ),
          // const SizedBox(height: 18),

          // ====================================================
          // TITLE
          // ====================================================
          Text(
            'Items availibility',
            style: AppTextStyles.subtitle.copyWith(
              color: Colors.black,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 8),

          // ====================================================
          // DESCRIPTION
          // ====================================================
          // Text(
          //   'Manage your restaurant menu easily.',
          //   style: AppTextStyles.body.copyWith(
          //     color: Colors.white.withValues(alpha: 0.82),
          //     height: 1.45,
          //   ),
          // ),

          // const SizedBox(height: 24),

          // ====================================================
          // STATISTICS
          // ====================================================
          Row(
            children: [
              // ==================================================
              // TOTAL ITEMS
              // ==================================================
              // Expanded(
              //   child: _buildStat(
              //     title: 'Total',
              //     value: totalItems.toString(),
              //     // icon: Icons.restaurant_menu_rounded,
              //   ),
              // ),

              // const SizedBox(width: 10),

              // ==================================================
              // AVAILABLE
              // ==================================================
              Expanded(
                child: _buildStat(
                  title: 'Available items',
                  value: availableItems.toString(),
                  // icon: Icons.check_circle_outline_rounded,
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // UNAVAILABLE
              // ==================================================
              Expanded(
                child: _buildStat(
                  title: 'Out of Stock',
                  value: unavailableItems.toString(),
                  // icon: Icons.remove_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStat({
    required String title,
    required String value,
    // required IconData icon,
  }) {
    return Container(
      // constraints: const BoxConstraints(minHeight: 116),

      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),

      decoration: BoxDecoration(
        color: AppColors.primary,

        borderRadius: BorderRadius.circular(18),

        // border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ======================================================
          // ICON
          // ======================================================
          // Container(
          //   width: 34,
          //   height: 34,

          //   decoration: BoxDecoration(
          //     color: Colors.white.withValues(alpha: 0.15),
          //     borderRadius: BorderRadius.circular(10),
          //   ),

          //   child: Icon(icon, color: Colors.white, size: 18),
          // ),

          // const SizedBox(height: 10),

          // ======================================================
          // VALUE
          // ======================================================
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title.copyWith(
              color: AppColors.white,
              fontSize: 21,
            ),
          ),

          const SizedBox(height: 2),

          // ======================================================
          // LABEL
          // ======================================================
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(
              color: AppColors.white,
              fontSize: 14
            ),
          ),
        ],
      ),
    );
  }
}
