import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteCategoryDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Category"),
      content: const Text("Are you sure you want to delete this category?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
