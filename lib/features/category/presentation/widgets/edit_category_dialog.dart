import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EditCategoryDialog extends StatefulWidget {
  final String initialValue;

  final Future<void> Function(String) onSave;

  const EditCategoryDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController controller;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // ============================================================
  // CLOSE
  // ============================================================

  void closeDialog() {
    if (loading) return;

    FocusScope.of(context).unfocus();

    Navigator.of(context).pop();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> save() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (loading) return;

    final categoryName = controller.text.trim();

    // Nothing changed.
    if (categoryName == widget.initialValue.trim()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await widget.onSave(categoryName);

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Category updated successfully',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

      child: Container(
        width: double.infinity,

        constraints: const BoxConstraints(maxWidth: 420),

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),

        child: Form(
          key: formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  // ------------------------------------------------
                  // ICON
                  // ------------------------------------------------
                  Container(
                    width: 52,
                    height: 52,

                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: const Icon(
                      Icons.edit_rounded,
                      color: AppColors.primary,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Edit Category',
                          style: AppTextStyles.title.copyWith(
                            color: const Color(0xff0F172A),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Update your category name',
                          style: AppTextStyles.small.copyWith(
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ------------------------------------------------
                  // CLOSE
                  // ------------------------------------------------
                  Container(
                    width: 38,
                    height: 38,

                    decoration: const BoxDecoration(
                      color: Color(0xffF1F5F9),
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      onPressed: loading ? null : closeDialog,

                      padding: EdgeInsets.zero,

                      icon: const Icon(
                        Icons.close_rounded,
                        size: 19,
                        color: Color(0xff475569),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // LABEL
              // ==================================================
              Text(
                'Category Name',
                style: AppTextStyles.label.copyWith(
                  color: const Color(0xff334155),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // CATEGORY INPUT
              // ==================================================
              TextFormField(
                controller: controller,

                autofocus: true,

                enabled: !loading,

                textCapitalization: TextCapitalization.words,

                textInputAction: TextInputAction.done,

                cursorColor: AppColors.primary,

                style: AppTextStyles.body.copyWith(
                  color: const Color(0xff0F172A),
                ),

                onFieldSubmitted: (_) {
                  if (!loading) {
                    save();
                  }
                },

                decoration: InputDecoration(
                  hintText: 'e.g. Beverages',

                  hintStyle: AppTextStyles.body.copyWith(
                    color: const Color(0xff94A3B8),
                  ),

                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primary,
                    size: 21,
                  ),

                  filled: true,

                  fillColor: const Color(0xffF8FAFC),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.red.shade500),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.red.shade500,
                      width: 1.5,
                    ),
                  ),

                  errorStyle: AppTextStyles.small.copyWith(
                    color: Colors.red.shade600,
                  ),
                ),

                validator: (value) {
                  final name = value?.trim() ?? '';

                  if (name.isEmpty) {
                    return 'Please enter category name';
                  }

                  if (name.length < 2) {
                    return 'Category name is too short';
                  }

                  if (name.length > 50) {
                    return 'Category name is too long';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              // ==================================================
              // HELPER
              // ==================================================
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: Color(0xff94A3B8),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      'Use a simple name customers can easily understand.',
                      style: AppTextStyles.small.copyWith(
                        color: const Color(0xff94A3B8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // ==================================================
              // BUTTONS
              // ==================================================
              Row(
                children: [
                  // ------------------------------------------------
                  // CANCEL
                  // ------------------------------------------------
                  Expanded(
                    child: SizedBox(
                      height: 50,

                      child: OutlinedButton(
                        onPressed: loading ? null : closeDialog,

                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff475569),

                          side: const BorderSide(color: Color(0xffE2E8F0)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: Text(
                          'Cancel',
                          style: AppTextStyles.button.copyWith(
                            color: const Color(0xff475569),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ------------------------------------------------
                  // UPDATE
                  // ------------------------------------------------
                  Expanded(
                    flex: 2,

                    child: SizedBox(
                      height: 50,

                      child: FilledButton(
                        onPressed: loading ? null : save,

                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,

                          foregroundColor: Colors.white,

                          disabledBackgroundColor: AppColors.primary.withValues(
                            alpha: 0.60,
                          ),

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  const Icon(Icons.check_rounded, size: 20),

                                  const SizedBox(width: 7),

                                  Text(
                                    'Update Category',
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
