import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String managerName;
  final String email;
  final String restaurantName;
  final String initial;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.managerName,
    required this.email,
    required this.restaurantName,
    required this.initial,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Initial Circle
          _buildProfileInitial(),

          const SizedBox(
            width: AppSpacing.lg,
          ),

          // User Information
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Manager Name
                Text(
                  managerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 22,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.xs,
                ),

                //Email
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.xs,
                ),

                // Restaurant Name
                Text(
                  restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight(5)
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.md,
                ),

                // Edit Profile Button
                SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                    ),
                    label: const Text(
                      'Edit Profile',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          AppRadius.sm,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInitial() {
    return Container(
      width: 96,
      height: 96,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(
          alpha: 0.10,
        ),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: 0.20,
          ),
          width: 3,
        ),
      ),
      child: Text(
        initial,
        style: AppTextStyles.title.copyWith(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}