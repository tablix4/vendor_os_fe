import 'package:flutter/material.dart';

class EmptyCategory extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyCategory({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category_outlined, size: 90, color: Colors.grey),
            const SizedBox(height: 25),
            const Text(
              "No Categories Yet",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Create your first category to organize your restaurant menu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text("Create Category"),
            ),
          ],
        ),
      ),
    );
  }
}
