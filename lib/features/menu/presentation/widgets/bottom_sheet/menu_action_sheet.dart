import 'package:flutter/material.dart';

import '../../../data/models/menu_item.dart';

class MenuActionSheet extends StatelessWidget {
  final MenuItemModel menu;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  final VoidCallback onToggleAvailability;

  final VoidCallback? onDuplicate;

  final VoidCallback? onChangeImage;

  const MenuActionSheet({
    super.key,
    required this.menu,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
    this.onDuplicate,
    this.onChangeImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green.shade50,
              child: const Icon(
                Icons.restaurant_menu,
                color: Color(0xff16A34A),
                size: 34,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              menu.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),

            const SizedBox(height: 6),

            Text(
              "₹${menu.price.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Color(0xff16A34A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 25),

            _tile(
              icon: Icons.edit,
              title: "Edit Menu",
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),

            // _tile(
            //   icon: Icons.copy,
            //   title: "Duplicate Menu",
            //   color: Colors.orange,
            //   onTap: () {
            //     Navigator.pop(context);
            //     onDuplicate?.call();
            //   },
            // ),

            // _tile(
            //   icon: Icons.image,
            //   title: "Change Image",
            //   color: Colors.deepPurple,
            //   onTap: () {
            //     Navigator.pop(context);
            //     onChangeImage?.call();
            //   },
            // ),
            _tile(
              icon: Icons.check_circle,
              title: menu.isAvailable
                  ? "Mark as Out of Stock"
                  : "Mark as Available",
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                onToggleAvailability();
              },
            ),

            _tile(
              icon: Icons.delete,
              title: "Delete Menu",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.12),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
