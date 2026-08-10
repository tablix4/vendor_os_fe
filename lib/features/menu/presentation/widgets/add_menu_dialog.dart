import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../data/models/create_menu_request.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/update_menu_request.dart';

import '../providers/menu_provider.dart';

import '../../../category/presentation/providers/category_provider.dart';

class AddMenuDialog extends ConsumerStatefulWidget {
  final MenuItemModel? menu;

  const AddMenuDialog({super.key, this.menu});

  bool get isEdit => menu != null;

  @override
  ConsumerState<AddMenuDialog> createState() => _AddMenuDialogState();
}

class _AddMenuDialogState extends ConsumerState<AddMenuDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController imageController = TextEditingController();

  String? selectedCategoryId;

  bool isAvailable = true;

  File? selectedImage;

  bool loading = false;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    if (widget.menu != null) {
      selectedCategoryId = widget.menu!.categoryId;

      nameController.text = widget.menu!.name;

      descriptionController.text = widget.menu!.description ?? '';

      priceController.text = widget.menu!.price.toString();

      imageController.text = widget.menu!.image ?? '';

      isAvailable = widget.menu!.isAvailable;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();

    super.dispose();
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
  // SAVE
  // ============================================================

  Future<void> save() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a category',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    if (loading) return;

    final price = double.tryParse(priceController.text.trim());

    if (price == null) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      if (widget.isEdit) {
        // ======================================================
        // UPDATE MENU
        // ======================================================

        await ref
            .read(menuProvider.notifier)
            .updateMenu(
              widget.menu!.id,
              UpdateMenuRequest(
                categoryId: selectedCategoryId!,
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                price: price,
                image: imageController.text.trim().isEmpty
                    ? null
                    : imageController.text.trim(),
                isAvailable: isAvailable,
              ),
            );
      } else {
        // ======================================================
        // CREATE MENU
        // ======================================================

        await ref
            .read(menuProvider.notifier)
            .createMenu(
              CreateMenuRequest(
                categoryId: selectedCategoryId!,
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                price: price,
                image: imageController.text.trim().isEmpty
                    ? null
                    : imageController.text.trim(),
                isAvailable: isAvailable,
              ),
            );
      }

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            widget.isEdit
                ? 'Menu updated successfully'
                : 'Menu created successfully',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
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
    final categories = ref.watch(categoryProvider);

    final screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      backgroundColor: Colors.transparent,

      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),

      child: Container(
        width: double.infinity,

        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: screenHeight * 0.88,
        ),

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

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 16, 16),

              child: Row(
                children: [
                  // --------------------------------------------
                  // HEADER ICON
                  // --------------------------------------------
                  // Container(
                  //   width: 50,
                  //   height: 50,

                  //   decoration: BoxDecoration(
                  //     color: AppColors.primary.withValues(alpha: 0.10),

                  //     borderRadius: BorderRadius.circular(15),
                  //   ),

                  //   child: Icon(
                  //     widget.isEdit
                  //         ? Icons.edit_rounded
                  //         : Icons.restaurant_menu_rounded,
                  //     color: AppColors.primary,
                  //     size: 25,
                  //   ),
                  // ),

                  // const SizedBox(width: 14),

                  // --------------------------------------------
                  // TITLE
                  // --------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          widget.isEdit ? 'Update Item' : 'Add Item',
                          style: AppTextStyles.title.copyWith(
                            color: const Color(0xff0F172A),
                          ),
                        ),

                        // const SizedBox(height: 3),

                        // Text(
                        //   widget.isEdit
                        //       ? 'Update item details and availability'
                        //       : 'Add something delicious to your menu',
                        //   style: AppTextStyles.small.copyWith(
                        //     color: const Color(0xff64748B),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // --------------------------------------------
                  // SWITCH
                  // --------------------------------------------
                  Transform.scale(
                    scale: 0.8,
                    child: Switch.adaptive(
                      value: isAvailable,
                      activeTrackColor: AppColors.primary,
                      onChanged: loading
                          ? null
                          : (value) {
                              setState(() {
                                isAvailable = value;
                              });
                            },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // --------------------------------------------
                  // CLOSE BUTTON
                  // --------------------------------------------
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
            ),

            const Divider(height: 1, color: Color(0xffF1F5F9)),

            // ==================================================
            // FORM
            // ==================================================
            Flexible(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),

                child: Form(
                  key: formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ========================================
                      // CATEGORY
                      // ========================================
                      _label('Category'),

                      const SizedBox(height: 8),

                      categories.when(
                        loading: () => Container(
                          height: 56,

                          alignment: Alignment.center,

                          decoration: _fieldDecoration(),

                          child: const SizedBox(
                            width: 20,
                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        error: (e, _) => Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.05),

                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: Text(
                            e.toString(),

                            style: AppTextStyles.small.copyWith(
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),

                        data: (items) {
                          return DropdownButtonFormField<String>(
                            initialValue: selectedCategoryId,

                            isExpanded: true,

                            style: AppTextStyles.body.copyWith(
                              color: const Color(0xff0F172A),
                            ),

                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xff64748B),
                            ),

                            dropdownColor: Colors.white,

                            borderRadius: BorderRadius.circular(14),

                            decoration: _inputDecoration(
                              hint: 'Select category',
                              icon: Icons.category_outlined,
                            ),

                            items: items
                                .map(
                                  (category) => DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(
                                      category.name,
                                      style: AppTextStyles.body,
                                    ),
                                  ),
                                )
                                .toList(),

                            onChanged: loading
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedCategoryId = value;
                                    });
                                  },

                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }

                              return null;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ========================================
                      // ITEM NAME
                      // ========================================
                      _label('Item Name'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: nameController,

                        textCapitalization: TextCapitalization.words,

                        textInputAction: TextInputAction.next,

                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xff0F172A),
                        ),

                        cursorColor: AppColors.primary,

                        decoration: _inputDecoration(
                          hint: 'e.g. Paneer Pizza',
                          icon: Icons.restaurant_outlined,
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter menu name';
                          }

                          if (value.trim().length < 2) {
                            return 'Menu name is too short';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ========================================
                      // DESCRIPTION
                      // ========================================
                      _label('Description', optional: true),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: descriptionController,

                        minLines: 3,
                        maxLines: 4,

                        textCapitalization: TextCapitalization.sentences,

                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xff0F172A),
                        ),

                        cursorColor: AppColors.primary,

                        decoration: _inputDecoration(
                          hint: 'Describe the item, ingredients, taste...',
                          // icon: Icons.notes_rounded,
                          alignIconTop: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ========================================
                      // PRICE
                      // ========================================
                      _label('Price'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: priceController,

                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),

                        textInputAction: TextInputAction.done,

                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xff0F172A),
                        ),

                        cursorColor: AppColors.primary,

                        decoration: _inputDecoration(
                          hint: '0.00',
                          icon: Icons.currency_rupee_rounded,
                          // prefix: '₹ ',
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter price';
                          }

                          final price = double.tryParse(value.trim());

                          if (price == null) {
                            return 'Invalid price';
                          }

                          if (price <= 0) {
                            return 'Price must be greater than 0';
                          }

                          return null;
                        },
                      ),

                      // ========================================
                      // EXISTING IMAGE
                      // ========================================
                      if (imageController.text.isNotEmpty) ...[
                        const SizedBox(height: 20),

                        _label('Item Image', optional: true),

                        const SizedBox(height: 8),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),

                          child: Stack(
                            children: [
                              Image.network(
                                imageController.text,

                                height: 150,
                                width: double.infinity,

                                fit: BoxFit.cover,

                                errorBuilder: (_, __, ___) => Container(
                                  height: 150,

                                  color: const Color(0xffF1F5F9),

                                  alignment: Alignment.center,

                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 42,
                                    color: Color(0xff94A3B8),
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 10,
                                right: 10,

                                child: Material(
                                  color: Colors.white,

                                  shape: const CircleBorder(),

                                  child: IconButton(
                                    tooltip: 'Remove image',

                                    onPressed: () {
                                      setState(() {
                                        imageController.clear();
                                      });
                                    },

                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 26),

                      // ========================================
                      // ACTION BUTTONS
                      // ========================================
                      Row(
                        children: [
                          // ------------------------------------
                          // CANCEL
                          // ------------------------------------
                          Expanded(
                            child: SizedBox(
                              height: 52,

                              child: OutlinedButton(
                                onPressed: loading ? null : _closeDialog,

                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xff475569),

                                  side: const BorderSide(
                                    color: Color(0xffE2E8F0),
                                  ),

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

                          // ------------------------------------
                          // CREATE / UPDATE
                          // ------------------------------------
                          Expanded(
                            flex: 1,

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        mainAxisSize: MainAxisSize.min,

                                        children: [
                                          Icon(
                                            widget.isEdit
                                                ? Icons.check_rounded
                                                : Icons.add_rounded,
                                            size: 20,
                                          ),

                                          const SizedBox(width: 7),

                                          Text(
                                            widget.isEdit
                                                ? 'Update'
                                                : 'Create',

                                            style: AppTextStyles.button
                                                .copyWith(color: Colors.white),
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
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _label(String text, {bool optional = false}) {
    return Row(
      children: [
        Text(
          text,

          style: AppTextStyles.label.copyWith(color: const Color(0xff334155)),
        ),

        if (optional) ...[
          const SizedBox(width: 5),

          Text(
            '(Optional)',

            style: AppTextStyles.small.copyWith(
              color: const Color(0xff94A3B8),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
    String? prefix,
    bool alignIconTop = false,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixText: prefix,

      prefixStyle: AppTextStyles.bodySemiBold.copyWith(
        color: const Color(0xff334155),
      ),

      prefixIcon: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: alignIconTop ? 12 : 0, left: 8),

              child: Icon(icon, size: 20, color: const Color(0xff64748B)),
            ),

      prefixIconConstraints: const BoxConstraints(minWidth: 40),

      hintStyle: AppTextStyles.body.copyWith(color: const Color(0xff94A3B8)),

      filled: true,

      fillColor: const Color(0xffF8FAFC),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // ========================================================
      // DEFAULT
      // ========================================================
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
      ),

      // ========================================================
      // ENABLED
      // ========================================================
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
      ),

      // ========================================================
      // FOCUSED
      // ========================================================
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),

      // ========================================================
      // ERROR
      // ========================================================
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(color: Colors.red.shade500),
      ),

      // ========================================================
      // FOCUSED ERROR
      // ========================================================
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(color: Colors.red.shade500, width: 1.5),
      ),

      errorStyle: AppTextStyles.small.copyWith(color: Colors.red.shade600),
    );
  }

  // ============================================================
  // LOADING FIELD
  // ============================================================

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: const Color(0xffF8FAFC),

      borderRadius: BorderRadius.circular(14),

      border: Border.all(color: const Color(0xffE2E8F0)),
    );
  }
}
