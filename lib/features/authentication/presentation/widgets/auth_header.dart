import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.storefront_rounded,
          size: 80,
          color: AppColors.primary,
        ),

        const SizedBox(height: 24),

        Text(
          title,
          style: AppTextStyles.heading,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 10),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}