import 'package:flutter/material.dart';
import 'bottom_sheet/menu_action_sheet.dart';
import '../../data/models/menu_item.dart';

class MenuCard extends StatelessWidget {
  final MenuItemModel menu;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  final ValueChanged<bool> onAvailabilityChanged;

  const MenuCard({
    super.key,
    required this.menu,
    required this.onEdit,
    required this.onDelete,
    required this.onAvailabilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildImage(),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            menu.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          "₹${menu.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Color(0xff16A34A),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        menu.categoryName,
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    if (menu.description != null &&
                        menu.description!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        menu.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: menu.isAvailable ? Colors.green : Colors.red,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          menu.isAvailable ? "Available" : "Out of Stock",
                          style: TextStyle(
                            color: menu.isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Switch(
                          value: menu.isAvailable,
                          activeColor: const Color(0xff16A34A),
                          onChanged: onAvailabilityChanged,
                        ),

                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              builder: (_) {
                                return MenuActionSheet(
                                  menu: menu,

                                  onEdit: onEdit,

                                  onDelete: onDelete,

                                  onToggleAvailability: () {
                                    onAvailabilityChanged(!menu.isAvailable);
                                  },

                                  onDuplicate: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Duplicate feature coming soon",
                                        ),
                                      ),
                                    );
                                  },

                                  onChangeImage: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Image upload coming soon",
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (menu.image != null && menu.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          menu.image!,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.restaurant_menu, size: 42, color: Colors.grey),
    );
  }
}
