import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/app_text_field.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = "Tea";

  bool isVeg = true;
  bool available = true;
  bool loading = false;

  final List<String> categories = ["Tea", "Coffee", "Snacks", "Juice", "Meal"];

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveItem() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Menu Item Added Successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),

                const SizedBox(width: 10),

                const Text(
                  "Add Menu Item",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                // TODO:
                // Pick Image using image_picker
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Upload Item Image"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            AppTextField(
              controller: nameController,
              label: "Item Name",
              hint: "Regular Tea",
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter item name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            AppTextField(
              controller: priceController,
              label: "Price",
              hint: "20",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter price";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Item Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text("Vegetarian"),
              value: isVeg,
              activeThumbColor: const Color(0xff16A34A),
              onChanged: (value) {
                setState(() {
                  isVeg = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text("Available"),
              value: available,
              activeThumbColor: const Color(0xff16A34A),
              onChanged: (value) {
                setState(() {
                  available = value;
                });
              },
            ),

            const SizedBox(height: 30),

            AppButton(text: "Save Item", loading: loading, onPressed: saveItem),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
