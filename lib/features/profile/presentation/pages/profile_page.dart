import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/auth/auth_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_page.dart';
import '../providers/profile_provider.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_page.dart';
import 'help_support_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  ConsumerState<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends ConsumerState<ProfilePage> {
  bool _isLoggingOut = false;
  String _appVersion = '';

  // Temporary URLs
  // Later, replace these with your actual URLs.
  static const String _privacyPolicyUrl =
      'https://www.google.com';

  static const String _termsConditionsUrl =
      'https://www.google.com';


  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo =
        await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _openUrl(
    String url,
  ) async {
    final Uri uri = Uri.parse(url);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open this page.',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open this page.',
          ),
        ),
      );
    }
  }

  Future<void> _openEditProfile({
    required String currentName,
    required String currentShopName,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EditProfilePage(
            currentName: currentName,
            currentShopName:
                currentShopName,
          );
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await AuthManager.logout();

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      context.go('/login');
    } catch (error) {
      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to logout. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          !_isLoggingOut,
      builder: (
        dialogContext,
      ) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return LogoutDialog(
              isLoading:
                  _isLoggingOut,
              onLogout: () async {
                setDialogState(
                  () {},
                );

                await _handleLogout();
              },
            );
          },
        );
      },
    );
  }

  // void _showComingSoon(
  //   String feature,
  // ) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         '$feature coming soon',
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    final profileState =
        ref.watch(
      profileProvider,
    );

    return AppPage(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style:
                AppTextStyles.title,
          ),

          const SizedBox(
            height:
                AppSpacing.xl,
          ),

          Expanded(
            child:
                profileState.when(
              loading: () {
                return const AppLoader();
              },

              error: (
                error,
                stackTrace,
              ) {
                return _buildErrorState();
              },

              data: (profile) {
                return RefreshIndicator(
                  color:
                      AppColors.primary,
                  onRefresh: () {
                    return ref
                        .read(
                          profileProvider
                              .notifier,
                        )
                        .refreshProfile();
                  },
                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: [
                      ProfileHeader(
                        managerName:
                            profile.name,
                        email: 
                            profile.email,
                        restaurantName:
                            profile.shopName,
                        initial:
                            profile.initial,
                        onEditProfile:
                            () {
                          _openEditProfile(
                            currentName:
                                profile.name,
                            currentShopName:
                                profile.shopName,
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.xl,
                      ),

                      // ProfileMenuItem(
                      //   icon: Icons
                      //       .storefront_outlined,
                      //   title:
                      //       'Restaurant Profile',
                      //   onTap: () {
                      //     _showComingSoon(
                      //       'Restaurant Profile',
                      //     );
                      //   },
                      // ),

                      // const SizedBox(
                      //   height:
                      //       AppSpacing.md,
                      // ),

                      ProfileMenuItem(
                        icon: Icons
                            .restaurant_menu_outlined,
                        title:
                            'Menu Management',
                        onTap: () {
                          context.go(
                            '/menu',
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.md,
                      ),

                      // ProfileMenuItem(
                      //   icon: Icons
                      //       .settings_outlined,
                      //   title:
                      //       'Business Settings',
                      //   onTap: () {
                      //     _showComingSoon(
                      //       'Business Settings',
                      //     );
                      //   },
                      // ),

                      // const SizedBox(
                      //   height:
                      //       AppSpacing.md,
                      // ),

                      // ProfileMenuItem(
                      //   icon: Icons
                      //       .notifications_none_outlined,
                      //   title:
                      //       'Notification Settings',
                      //   onTap: () {
                      //     _showComingSoon(
                      //       'Notification Settings',
                      //     );
                      //   },
                      // ),

                      // const SizedBox(
                      //   height:
                      //       AppSpacing.md,
                      // ),

                      ProfileMenuItem(
                        icon: Icons
                            .help_outline,
                        title:
                            'Help & Support',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const HelpSupportPage();
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.md,
                      ),

                      ProfileMenuItem(
                        icon: Icons
                            .privacy_tip_outlined,
                        title:
                            'Privacy Policy',
                        onTap: () {
                          _openUrl(
                            _privacyPolicyUrl,
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.md,
                      ),

                      ProfileMenuItem(
                        icon: Icons
                            .description_outlined,
                        title:
                            'Terms & Conditions',
                        onTap: () {
                          _openUrl(
                            _termsConditionsUrl,
                          );
                        },
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.xl,
                      ),

                      const Divider(
                        color:
                            AppColors.border,
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.lg,
                      ),

                      ProfileMenuItem(
                        icon:
                            Icons.logout,
                        title:
                            'Logout',
                        isDestructive:
                            true,
                        onTap:
                            _showLogoutDialog,
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.lg,
                      ),

                      // App Version
                      if (_appVersion.isNotEmpty)
                        Center(
                          child: Text(
                            'Version $_appVersion',
                            style: AppTextStyles
                                .caption
                                .copyWith(
                              fontSize: 12,
                              color:
                                  AppColors.grey,
                            ),
                          ),
                        ),

                      const SizedBox(
                        height:
                            AppSpacing.xl,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color:
                  AppColors.error,
            ),

            const SizedBox(
              height:
                  AppSpacing.lg,
            ),

            Text(
              'Unable to load profile',
              style: AppTextStyles
                  .body
                  .copyWith(
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.sm,
            ),

            Text(
              'Please check your connection and try again.',
              textAlign:
                  TextAlign.center,
              style:
                  AppTextStyles.caption,
            ),

            const SizedBox(
              height:
                  AppSpacing.xl,
            ),

            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(
                      profileProvider
                          .notifier,
                    )
                    .fetchProfile();
              },
              icon:
                  const Icon(
                Icons.refresh,
              ),
              label:
                  const Text(
                'Try Again',
              ),
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}