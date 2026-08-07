import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/app_text_field.dart';

import '../../data/models/complete_profile_request.dart';
import '../../data/services/auth_service.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopController = TextEditingController();

  final AuthService _authService = AuthService();

  bool loading = false;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    shopController.dispose();

    super.dispose();
  }

  // ============================================================
  // COMPLETE PROFILE
  // ============================================================

  Future<void> continuePressed() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final tempToken = await StorageService.getTempToken();

      debugPrint('========== COMPLETE PROFILE ==========');
      debugPrint('TEMP TOKEN => $tempToken');

      if (tempToken == null || tempToken.isEmpty) {
        throw Exception('Session expired. Please login again.');
      }

      final response = await _authService.completeProfile(
        tempToken,
        CompleteProfileRequest(
          name: nameController.text.trim(),
          shopName: shopController.text.trim(),
        ),
      );

      debugPrint('PROFILE RESPONSE => ${response.message}');

      // ========================================================
      // SAVE AUTHENTICATED SESSION
      // ========================================================

      await StorageService.saveAccessToken(response.data.accessToken);

      await StorageService.saveRefreshToken(response.data.refreshToken);

      // Temporary registration token is no longer required.
      await StorageService.clearTempToken();

      if (!mounted) return;

      _showSuccessMessage(response.message);

      context.go('/dashboard');
    } catch (e) {
      debugPrint('COMPLETE PROFILE ERROR => $e');

      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              // ==================================================
              // LOGO
              // ==================================================
              const Center(child: AppLogo(size: 70)),

              const SizedBox(height: 34),

              // ==================================================
              // TITLE
              // ==================================================
              Text(
                'Complete Profile',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 10),

              // ==================================================
              // DESCRIPTION
              // ==================================================
              Text(
                'Tell us a little about yourself and your business.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 36),

              // ==================================================
              // PERSONAL INFORMATION LABEL
              // ==================================================
              Text('Your Information', style: AppTextStyles.label),

              const SizedBox(height: 10),

              // ==================================================
              // FULL NAME
              // ==================================================
              AppTextField(
                controller: nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }

                  if (value.trim().length < 2) {
                    return 'Please enter a valid name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ==================================================
              // BUSINESS INFORMATION LABEL
              // ==================================================
              Text('Business Information', style: AppTextStyles.label),

              const SizedBox(height: 10),

              // ==================================================
              // SHOP NAME
              // ==================================================
              AppTextField(
                controller: shopController,
                label: 'Shop Name',
                hint: 'Enter your shop name',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter shop name';
                  }

                  if (value.trim().length < 2) {
                    return 'Please enter a valid shop name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // HELPER TEXT
              // ==================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Color(0xff94A3B8),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      'Your shop name will be used throughout the app for managing your menu and orders.',
                      style: AppTextStyles.small.copyWith(
                        color: const Color(0xff94A3B8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // ==================================================
              // CONTINUE BUTTON
              // ==================================================
              AppButton(
                text: 'Continue',
                loading: loading,
                onPressed: continuePressed,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // FOOTER
              // ==================================================
              Text(
                'You can update these details later from your profile.',
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: const Color(0xff94A3B8),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
