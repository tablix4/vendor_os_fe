import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final Future<void> Function(String name) onSave;

  final String title;

  final String buttonText;

  final String? initialValue;

  const AddCategoryDialog({
    super.key,
    required this.onSave,
    this.title = "Add Category",
    this.buttonText = "Create",
    this.initialValue,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController controller;

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

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
            widget.buttonText == "Create"
                ? "Category created successfully"
                : "Category updated successfully",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),

      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Category Name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter category name";
            }

            return null;
          },
        ),
      ),

      actions: [
        TextButton(
          onPressed: loading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text("Cancel"),
        ),

        FilledButton(
          onPressed: loading ? null : save,
          child: loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(widget.buttonText),
        ),
      ],
    );
  }
}
