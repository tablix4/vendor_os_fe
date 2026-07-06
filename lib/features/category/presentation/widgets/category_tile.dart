import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const CategoryTile({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xff16A34A).withOpacity(.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.category,
                    color: Color(0xff16A34A),
                    size: 30,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${category.itemCount} Menu Items",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "edit") {
                      onEdit?.call();
                    }

                    if (value == "delete") {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit),

                          SizedBox(width: 10),

                          Text("Edit"),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),

                          SizedBox(width: 10),

                          Text("Delete", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Divider(color: Colors.grey.shade200),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey.shade500, size: 18),

                const SizedBox(width: 8),

                Text(
                  "Last Updated ${DateFormat('dd MMM yyyy • hh:mm a').format(category.updatedAt)}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
