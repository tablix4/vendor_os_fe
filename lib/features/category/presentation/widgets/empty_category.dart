import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EmptyCategory extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyCategory({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // EMPTY STATE ILLUSTRATION
            // ==================================================
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer soft circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),

                // Middle circle
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),

                // Category icon
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),

                // Small add badge
                Positioned(
                  right: 15,
                  bottom: 14,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ==================================================
            // TITLE
            // ==================================================
            Text(
              'No Categories Yet',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: const Color(0xff0F172A),
              ),
            ),

            const SizedBox(height: 8),

            // ==================================================
            // DESCRIPTION
            // ==================================================
            Text(
              'Create your first category to keep your menu organized.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xff64748B),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'For example: Pizza, Burgers, Beverages or Desserts.',
              textAlign: TextAlign.center,
              style: AppTextStyles.small.copyWith(
                color: const Color(0xff94A3B8),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // CREATE CATEGORY BUTTON
            // ==================================================
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 21),
                label: Text(
                  'Create Category',
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
