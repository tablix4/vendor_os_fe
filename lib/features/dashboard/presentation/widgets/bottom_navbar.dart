import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardBottomBar extends StatelessWidget {
  final int currentIndex;

  const DashboardBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      height: 75,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.push("/dashboard");
            break;

          case 1:
            context.push("/menu");
            break;

          case 2:
            context.push("/orders");
            break;

          case 3:
            context.push("/profile");
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: "Category",
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: "Menu",
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: "Orders",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
