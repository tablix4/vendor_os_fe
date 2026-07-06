import 'package:flutter/material.dart';

class MenuDialogHeader extends StatelessWidget {
  final bool isEdit;

  const MenuDialogHeader({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Drag Handle
        Container(
          width: 55,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(50),
          ),
        ),

        const SizedBox(height: 22),

        CircleAvatar(
          radius: 34,
          backgroundColor: const Color(0xff16A34A).withOpacity(.12),
          child: Icon(
            isEdit ? Icons.edit : Icons.restaurant_menu,
            color: const Color(0xff16A34A),
            size: 34,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          isEdit ? "Update Menu Item" : "Add Menu Item",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: .3,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          isEdit
              ? "Update your restaurant menu item."
              : "Create a new delicious menu item.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        Divider(color: Colors.grey.shade200, thickness: 1, height: 1),

        const SizedBox(height: 24),
      ],
    );
  }
}
