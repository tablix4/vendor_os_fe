import 'package:flutter/material.dart';

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
  static const Color primaryGreen = Color(0xff16A34A);

  late final TextEditingController controller;

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  bool get isEdit => widget.initialValue != null;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Category updated successfully'
                : 'Category created successfully',
          ),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              // ================================================
              // HEADER
              // ================================================
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryGreen.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isEdit ? Icons.edit_rounded : Icons.category_rounded,
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
                          widget.title,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0F172A),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          isEdit
                              ? 'Update category details'
                              : 'Organize your menu items',
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
                      onPressed: loading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
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

              // ================================================
              // LABEL
              // ================================================
              const Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff334155),
                ),
              ),

              const SizedBox(height: 8),

              // ================================================
              // CATEGORY FIELD
              // ================================================
              TextFormField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (!loading) {
                    save();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'e.g. Pizza, Drinks, Desserts',

                  hintStyle: const TextStyle(color: Color(0xff94A3B8)),

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
                      color: primaryGreen,
                      width: 1.5,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter category name';
                  }

                  if (value.trim().length < 2) {
                    return 'Category name is too short';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: Color(0xff94A3B8),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Categories help you organize menu items.',
                      style: TextStyle(fontSize: 12, color: Color(0xff94A3B8)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================================================
              // BUTTONS
              // ================================================
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: loading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff475569),
                          side: const BorderSide(color: Color(0xffE2E8F0)),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
