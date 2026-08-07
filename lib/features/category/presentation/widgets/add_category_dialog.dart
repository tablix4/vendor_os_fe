import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddCategoryDialog extends StatefulWidget {
  final Future<void> Function(String name) onSave;
  final String title;
  final String buttonText;
  final String? initialValue;

  const AddCategoryDialog({
    super.key,
    required this.onSave,
    this.title = 'Add Category',
    this.buttonText = 'Create',
    this.initialValue,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController controller;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  bool get isEdit => widget.initialValue != null;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE CATEGORY
  // ============================================================

  Future<void> save() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      await widget.onSave(controller.text.trim());

      if (!mounted) return;

      Navigator.pop(context);

      // CategoryPage can also show this message if you want
      // centralized SnackBar handling.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Category updated successfully'
                : 'Category created successfully',
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
  // CLOSE DIALOG
  // ============================================================

  void _closeDialog() {
    if (loading) return;

    FocusScope.of(context).unfocus();

    Navigator.pop(context);
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,

          constraints: const BoxConstraints(maxWidth: 440),

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(26),

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
                    // ----------------------------------------------
                    // ICON
                    // ----------------------------------------------
                    Container(
                      width: 50,
                      height: 50,

                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Icon(
                        isEdit ? Icons.edit_rounded : Icons.category_rounded,
                        color: AppColors.primary,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // ----------------------------------------------
                    // TITLE
                    // ----------------------------------------------
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppTextStyles.title.copyWith(
                              color: const Color(0xff0F172A),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            isEdit
                                ? 'Update category details'
                                : 'Organize your menu items',
                            style: AppTextStyles.small.copyWith(
                              color: const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ----------------------------------------------
                    // CLOSE
                    // ----------------------------------------------
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xffF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: 'Close',
                        padding: EdgeInsets.zero,
                        onPressed: loading ? null : _closeDialog,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Color(0xff475569),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // ==================================================
                // CATEGORY LABEL
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

                  textCapitalization: TextCapitalization.words,

                  textInputAction: TextInputAction.done,

                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xff0F172A),
                  ),

                  cursorColor: AppColors.primary,

                  onFieldSubmitted: (_) {
                    if (!loading) {
                      save();
                    }
                  },

                  decoration: InputDecoration(
                    hintText: 'e.g. Pizza, Drinks, Desserts',

                    hintStyle: AppTextStyles.body.copyWith(
                      color: const Color(0xff94A3B8),
                    ),

                    prefixIcon: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: Color(0xff64748B),
                      size: 21,
                    ),

                    filled: true,

                    fillColor: const Color(0xffF8FAFC),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    // --------------------------------------------
                    // NORMAL BORDER
                    // --------------------------------------------
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                    ),

                    // --------------------------------------------
                    // FOCUS BORDER
                    // --------------------------------------------
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),

                    // --------------------------------------------
                    // ERROR BORDER
                    // --------------------------------------------
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
                    final categoryName = value?.trim() ?? '';

                    if (categoryName.isEmpty) {
                      return 'Please enter category name';
                    }

                    if (categoryName.length < 2) {
                      return 'Category name is too short';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // ==================================================
                // HELPER TEXT
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: Color(0xff94A3B8),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        'Categories help you organize menu items.',
                        style: AppTextStyles.small.copyWith(
                          color: const Color(0xff94A3B8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ==================================================
                // ACTION BUTTONS
                // ==================================================
                Row(
                  children: [
                    // ----------------------------------------------
                    // CANCEL
                    // ----------------------------------------------
                    Expanded(
                      child: SizedBox(
                        height: 52,

                        child: OutlinedButton(
                          onPressed: loading ? null : _closeDialog,

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

                    // ----------------------------------------------
                    // CREATE / UPDATE
                    // ----------------------------------------------
                    Expanded(
                      flex: 2,

                      child: SizedBox(
                        height: 52,

                        child: FilledButton(
                          onPressed: loading ? null : save,

                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,

                            foregroundColor: Colors.white,

                            disabledBackgroundColor: AppColors.primary
                                .withValues(alpha: 0.65),

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
                                    Icon(
                                      isEdit
                                          ? Icons.check_rounded
                                          : Icons.add_rounded,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 7),

                                    Text(
                                      widget.buttonText,
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
      ),
    );
  }
}
