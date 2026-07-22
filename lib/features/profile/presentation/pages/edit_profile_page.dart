import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/profile_provider.dart';

class EditProfilePage
    extends ConsumerStatefulWidget {
  final String currentName;
  final String currentShopName;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentShopName,
  });

  @override
  ConsumerState<EditProfilePage>
      createState() =>
          _EditProfilePageState();
}

class _EditProfilePageState
    extends ConsumerState<
        EditProfilePage> {
  final _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _nameController;

  late final TextEditingController
      _shopNameController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
      text: widget.currentName,
    );

    _shopNameController =
        TextEditingController(
      text: widget.currentShopName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();

    super.dispose();
  }

  Future<void>
      _saveProfile() async {
    FocusScope.of(context)
        .unfocus();

    final isValid =
        _formKey.currentState
                ?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(
            profileProvider.notifier,
          )
          .updateProfile(
            name: _nameController
                .text
                .trim(),
            shopName:
                _shopNameController
                    .text
                    .trim(),
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully',
          ),
        ),
      );

      Navigator.of(context).pop();
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      final message =
          _getDioErrorMessage(
        error,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update profile. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _getDioErrorMessage(
    DioException error,
  ) {
    final responseData =
        error.response?.data;

    if (responseData
        is Map<String, dynamic>) {
      final message =
          responseData['message'];

      if (message is String &&
          message.isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message
            .join('\n');
      }
    }

    return 'Unable to update profile. Please try again.';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        backgroundColor:
            AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: _isSaving
              ? null
              : () {
                  Navigator.of(context)
                      .pop();
                },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: Text(
          'Edit Profile',
          style:
              AppTextStyles.title.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding:
                const EdgeInsets.all(
              AppSpacing.lg,
            ),
            children: [
              Text(
                'Manager Name',
                style:
                    AppTextStyles.body.copyWith(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              TextFormField(
                controller:
                    _nameController,
                textInputAction:
                    TextInputAction.next,
                enabled: !_isSaving,
                decoration:
                    _inputDecoration(
                  hintText:
                      'Enter manager name',
                  icon:
                      Icons.person_outline,
                ),
                validator: (value) {
                  final name =
                      value?.trim() ??
                          '';

                  if (name.isEmpty) {
                    return 'Please enter manager name';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              Text(
                'Restaurant Name',
                style:
                    AppTextStyles.body.copyWith(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              TextFormField(
                controller:
                    _shopNameController,
                textInputAction:
                    TextInputAction.done,
                enabled: !_isSaving,
                onFieldSubmitted: (_) {
                  _saveProfile();
                },
                decoration:
                    _inputDecoration(
                  hintText:
                      'Enter restaurant name',
                  icon: Icons
                      .storefront_outlined,
                ),
                validator: (value) {
                  final shopName =
                      value?.trim() ??
                          '';

                  if (shopName.isEmpty) {
                    return 'Please enter restaurant name';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              SizedBox(
                width: double.infinity,
                height: 52,
                child:
                    ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : _saveProfile,
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor:
                        AppColors.white,
                    disabledBackgroundColor:
                        AppColors.primary
                            .withValues(
                      alpha: 0.50,
                    ),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        AppRadius.md,
                      ),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                AppColors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        icon,
        color: AppColors.grey,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide:
            const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide:
            const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide:
            const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          AppRadius.md,
        ),
        borderSide:
            const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }
}