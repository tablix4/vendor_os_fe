import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  static const Color primaryGreen = Color(0xff16A34A);

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  final priceController = TextEditingController();

  final imageController = TextEditingController();

  String? selectedCategoryId;

  bool isAvailable = true;

  File? selectedImage;

  bool loading = false;

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

  Future<void> save() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));

      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      if (widget.isEdit) {
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
                price: double.parse(priceController.text.trim()),
                image: imageController.text.trim().isEmpty
                    ? null
                    : imageController.text.trim(),
                isAvailable: isAvailable,
              ),
            );
      } else {
        await ref
            .read(menuProvider.notifier)
            .createMenu(
              CreateMenuRequest(
                categoryId: selectedCategoryId!,
                name: nameController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                price: double.parse(priceController.text.trim()),
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
          backgroundColor: primaryGreen,
          content: Text(
            widget.isEdit
                ? 'Menu updated successfully'
                : 'Menu created successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString().replaceFirst('Exception: ', '')),
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
            // ================================================
            // HEADER
            // ================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 16, 16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryGreen.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      widget.isEdit
                          ? Icons.edit_rounded
                          : Icons.restaurant_menu_rounded,
                      color: primaryGreen,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isEdit ? 'Update Menu Item' : 'Add Menu Item',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0F172A),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          widget.isEdit
                              ? 'Update item details and availability'
                              : 'Add something delicious to your menu',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: loading ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xffF1F5F9)),

            // ================================================
            // FORM
            // ================================================
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
                      // ======================================
                      // CATEGORY
                      // ======================================
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
                            child: CircularProgressIndicator(strokeWidth: 2),
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
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                        data: (items) {
                          return DropdownButtonFormField<String>(
                            value: selectedCategoryId,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: _inputDecoration(
                              hint: 'Select category',
                              icon: Icons.category_outlined,
                            ),
                            items: items
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
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

                      // ======================================
                      // NAME
                      // ======================================
                      _label('Item Name'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration(
                          hint: 'e.g. Paneer Pizza',
                          icon: Icons.restaurant_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter menu name';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ======================================
                      // DESCRIPTION
                      // ======================================
                      _label('Description', optional: true),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: _inputDecoration(
                          hint: 'Describe the item, ingredients, taste...',
                          icon: Icons.notes_rounded,
                          alignIconTop: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================================
                      // PRICE
                      // ======================================
                      _label('Price'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _inputDecoration(
                          hint: '0.00',
                          prefix: '₹ ',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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

                      // ======================================
                      // EXISTING IMAGE
                      // ======================================
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

                      const SizedBox(height: 22),

                      // ======================================
                      // AVAILABILITY
                      // ======================================
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? primaryGreen.withValues(alpha: 0.06)
                              : const Color(0xffF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isAvailable
                                ? primaryGreen.withValues(alpha: 0.25)
                                : const Color(0xffE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? primaryGreen.withValues(alpha: 0.12)
                                    : const Color(0xffF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isAvailable
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: isAvailable
                                    ? primaryGreen
                                    : const Color(0xff64748B),
                                size: 21,
                              ),
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0F172A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Visible for customers and new orders',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Switch.adaptive(
                              value: isAvailable,
                              activeTrackColor: primaryGreen,
                              onChanged: loading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        isAvailable = value;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // ======================================
                      // ACTIONS
                      // ======================================
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: loading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xff475569),
                                  side: const BorderSide(
                                    color: Color(0xffE2E8F0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: loading ? null : save,
                                style: FilledButton.styleFrom(
                                  backgroundColor: primaryGreen,
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
                                                ? 'Update Menu'
                                                : 'Create Menu',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff334155),
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 5),
          const Text(
            '(Optional)',
            style: TextStyle(fontSize: 11, color: Color(0xff94A3B8)),
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

      prefixIcon: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: alignIconTop ? 12 : 0),
              child: Icon(icon, size: 20, color: const Color(0xff64748B)),
            ),

      prefixIconConstraints: const BoxConstraints(minWidth: 48),

      hintStyle: const TextStyle(color: Color(0xff94A3B8), fontSize: 14),

      filled: true,
      fillColor: const Color(0xffF8FAFC),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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
        borderSide: const BorderSide(color: primaryGreen, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  // ============================================================
  // FIELD PLACEHOLDER
  // ============================================================

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: const Color(0xffF8FAFC),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xffE2E8F0)),
    );
  }
}
