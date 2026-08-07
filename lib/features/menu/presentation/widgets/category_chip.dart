import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(30),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),

            curve: Curves.easeInOut,

            constraints: const BoxConstraints(minHeight: 44),

            padding: EdgeInsets.symmetric(
              horizontal: selected ? 17 : 16,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              // ================================================
              // BACKGROUND
              // ================================================
              color: selected ? AppColors.primary : Colors.white,

              borderRadius: BorderRadius.circular(30),

              // ================================================
              // BORDER
              // ================================================
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xffE2E8F0),
                width: 1,
              ),

              // ================================================
              // SHADOW
              // ================================================
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.025),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                // ==============================================
                // SELECTED INDICATOR
                // ==============================================
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),

                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },

                  child: selected
                      ? Container(
                          key: const ValueKey('selected'),

                          width: 20,
                          height: 20,

                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('unselected')),
                ),

                if (selected) const SizedBox(width: 7),

                // ==============================================
                // CATEGORY NAME
                // ==============================================
                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: selected ? Colors.white : const Color(0xff475569),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
