import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xff16A34A),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TABLIX",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Restaurant Management",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Badge(
            child: Icon(Icons.notifications_none),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}