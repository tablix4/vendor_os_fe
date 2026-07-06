import 'package:flutter/material.dart';

class MenuSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MenuSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        onChanged: onChanged,

        decoration: InputDecoration(
          hintText: "Search menu items...",

          hintStyle: TextStyle(color: Colors.grey.shade500),

          prefixIcon: const Icon(Icons.search, color: Color(0xff16A34A)),

          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    onChanged("");
                  },
                ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
