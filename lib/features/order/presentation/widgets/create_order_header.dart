import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablix/core/theme/app_colors.dart';
import 'package:tablix/core/theme/app_text_styles.dart';

class CreateOrderHeader extends StatelessWidget {
  const CreateOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // return Row(
    //   children: [
    //     IconButton(
    //       onPressed: () => context.pop(),
    //       icon: const Icon(Icons.arrow_back_ios_new_rounded),
    //     ),

    //     const SizedBox(width: 8),

    //     const Expanded(
    //       child: Text(
    //         "Create New Order",
    //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   ],
    // );

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,

      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
      ),

      title: Text(
        'Create New Order',
        style: AppTextStyles.heading.copyWith(fontSize: 24),
      ),

      titleSpacing: 0,

      centerTitle: false,
    );
  }
}
