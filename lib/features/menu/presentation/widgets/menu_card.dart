import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_hr/core/theme/app_colors.dart';

import '../../data/models/menu_item.dart';
import '../../../category/presentation/widgets/slidable_action_button.dart';

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
    return Slidable(
      key: ValueKey(menu.id),

      // LEFT SIDE → EDIT
      startActionPane: ActionPane(
        extentRatio: .30,
        motion: const StretchMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              onEdit();
            },
            backgroundColor: Colors.transparent,
            child: SlidableActionButton(
              icon: Icons.edit_rounded,
              title: "Edit",
              color: AppColors.primary,
              onTap: onEdit,
            ),
          ),
        ],
      ),

      // RIGHT SIDE → DELETE
      endActionPane: ActionPane(
        extentRatio: .30,
        motion: const StretchMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              onDelete();
            },
            backgroundColor: Colors.transparent,
            child: SlidableActionButton(
              icon: Icons.delete_forever_rounded,
              title: "Delete",
              color: Colors.red,
              onTap: onDelete,
            ),
          ),
        ],
      ),

      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu image intentionally kept hidden
              // _buildImage(),

              // const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MENU NAME + PRICE
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

                    // CATEGORY
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

                    // DESCRIPTION
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

                    const SizedBox(height: 0),

                    // AVAILABILITY + SWITCH
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color:
                              menu.isAvailable ? Colors.green : Colors.red,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          menu.isAvailable
                              ? "Available"
                              : "Out of Stock",
                          style: TextStyle(
                            color: menu.isAvailable
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: menu.isAvailable,
                            activeThumbColor: const Color.fromARGB(
                              255,
                              254,
                              254,
                              254,
                            ),
                            onChanged: onAvailabilityChanged,
                          ),
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
      child: const Icon(
        Icons.restaurant_menu,
        size: 42,
        color: Colors.grey,
      ),
    );
  }
}
