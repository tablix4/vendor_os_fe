import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dialog/menu_image_picker.dart';
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

      descriptionController.text = widget.menu!.description ?? "";

      priceController.text = widget.menu!.price.toString();

      imageController.text = widget.menu!.image ?? "";

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
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a category")));

      return;
    }

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
                price: double.parse(priceController.text),
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
                price: double.parse(priceController.text),
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
          backgroundColor: Colors.green,
          content: Text(
            widget.isEdit
                ? "Menu updated successfully"
                : "Menu created successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
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

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEdit ? "Update Menu Item" : "Add Menu Item",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.isEdit
                    ? "Update your menu item details."
                    : "Create a new menu item.",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 28),

              // Category Dropdown starts here...
              categories.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) => Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                ),

                data: (items) {
                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: "Category",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: items
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Menu Name",
                  hintText: "Paneer Pizza",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter menu name";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Cheesy Pizza with fresh toppings",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: "Price",
                  prefixText: "₹ ",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter price";
                  }

                  if (double.tryParse(value) == null) {
                    return "Invalid price";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // TextFormField(
              //   controller: imageController,
              //   decoration: InputDecoration(
              //     labelText: "Image URL (Optional)",
              //     hintText: "https://example.com/pizza.jpg",
              //     filled: true,
              //     fillColor: Colors.grey.shade100,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(14),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              // ),
              if (imageController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      imageController.text,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 42),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              SwitchListTile.adaptive(
                value: isAvailable,
                activeColor: const Color.fromARGB(255, 255, 255, 255),
                contentPadding: EdgeInsets.zero,
                title: const Text("Available"),
                subtitle: const Text("Visible for customers"),
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),

              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff16A34A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: loading ? null : save,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(widget.isEdit ? Icons.save : Icons.add),
                  label: Text(
                    widget.isEdit ? "Update Menu" : "Create Menu",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
