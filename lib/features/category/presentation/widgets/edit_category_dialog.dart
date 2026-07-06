import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {
  final String initialValue;

  final Future<void> Function(String) onSave;

  const EditCategoryDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late final TextEditingController controller;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    await widget.onSave(controller.text.trim());

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Category"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Category Name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: loading ? null : save,
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}
