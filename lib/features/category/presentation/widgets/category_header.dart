import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryHeader extends StatelessWidget {
  final int totalCategories;
  final VoidCallback onAdd;

  const CategoryHeader({
    super.key,
    required this.totalCategories,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xff15803D)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // TOP ICON
          // ====================================================
          // Container(
          //   width: 46,
          //   height: 46,
          //   decoration: BoxDecoration(
          //     color: Colors.white.withValues(alpha: 0.16),
          //     borderRadius: BorderRadius.circular(14),
          //   ),
          //   child: const Icon(
          //     Icons.category_rounded,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          // ),

          // const SizedBox(height: 18),

          // ====================================================
          // TITLE
          // ====================================================
          Text(
            'Categories',
            style: AppTextStyles.heading.copyWith(
              color: Colors.white,
              fontSize: 27,
            ),
          ),

          const SizedBox(height: 8),

          // ====================================================
          // DESCRIPTION
          // ====================================================
          Text(
            'Organize your restaurant menu into categories.',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.45,
            ),
          ),

          const SizedBox(height: 24),

          // ====================================================
          // STAT + ADD BUTTON
          // ====================================================
          Row(
            children: [
              // ==================================================
              // TOTAL CATEGORY CARD
              // ==================================================
              Expanded(
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // ------------------------------------------
                      // SMALL ICON
                      // ------------------------------------------
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ------------------------------------------
                      // LABEL
                      // ------------------------------------------
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyles.small.copyWith(
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                            ),

                            const SizedBox(height: 1),

                            Text(
                              'Categories',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySemiBold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ------------------------------------------
                      // COUNT
                      // ------------------------------------------
                      Container(
                        constraints: const BoxConstraints(minWidth: 38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$totalCategories',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // ADD BUTTON
              // ==================================================
              SizedBox(
                height: 64,
                child: FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, size: 21),

                      const SizedBox(width: 6),

                      Text(
                        'Add',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
