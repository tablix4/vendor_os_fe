import 'package:flutter/material.dart';

class MenuEmpty extends StatelessWidget {
  final VoidCallback onAdd;

  const MenuEmpty({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.restaurant_menu_rounded,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 18),
          const Text(
            "No Menu Items",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Create your first menu item",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(
                Icons.add,
                color: Color(0xff16A34A),
            ),
            label: const Text(
                "Add Menu",
                style: TextStyle(color: Color(0xff16A34A),),
            ),
          ),
        ],
      ),
    );
  }
}
