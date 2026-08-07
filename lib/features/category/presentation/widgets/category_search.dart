import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategorySearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CategorySearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          final hasText = value.text.trim().isNotEmpty;

          return TextField(
            controller: controller,

            onChanged: onChanged,

            keyboardType: TextInputType.text,

            textInputAction: TextInputAction.search,

            style: AppTextStyles.body.copyWith(color: const Color(0xff0F172A)),

            cursorColor: AppColors.primary,

            decoration: InputDecoration(
              // ==================================================
              // HINT
              // ==================================================
              hintText: 'Search categories...',

              hintStyle: AppTextStyles.body.copyWith(
                color: const Color(0xff94A3B8),
              ),

              // ==================================================
              // SEARCH ICON
              // ==================================================
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 4, right: 2),
                child: Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: hasText ? AppColors.primary : const Color(0xff94A3B8),
                ),
              ),

              prefixIconConstraints: const BoxConstraints(minWidth: 48),

              // ==================================================
              // CLEAR BUTTON
              // ==================================================
              suffixIcon: hasText
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          controller.clear();

                          onChanged('');
                        },
                        icon: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xffF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 17,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ),
                    )
                  : null,

              // ==================================================
              // FIELD STYLE
              // ==================================================
              filled: true,

              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              // ==================================================
              // NORMAL BORDER
              // ==================================================
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xffE2E8F0),
                  width: 1,
                ),
              ),

              // ==================================================
              // FOCUSED BORDER
              // ==================================================
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),

              // ==================================================
              // DEFAULT BORDER
              // ==================================================
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
            ),
          );
        },
      ),
    );
  }
}
