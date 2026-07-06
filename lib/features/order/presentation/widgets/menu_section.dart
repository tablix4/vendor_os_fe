import 'package:flutter/material.dart';

import '../../../menu/data/models/menu_item.dart';
import 'menu_item_selector_card.dart';

class MenuSection extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const MenuSection({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    if (menuItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No menu items found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 150),
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return MenuItemSelectorCard(item: menuItems[index]);
      },
    );
  }
}
