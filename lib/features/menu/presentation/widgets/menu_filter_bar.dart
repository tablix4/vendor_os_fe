import 'package:flutter/material.dart';

import '../../../category/data/models/category_model.dart';

class MenuFilterBar extends StatelessWidget {
  final List<CategoryModel> categories;

  final String? selectedCategoryId;

  final ValueChanged<String?> onCategorySelected;

  const MenuFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(
            title: "All",
            selected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),

          const SizedBox(width: 10),

          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _buildChip(
                title: category.name,
                selected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Material(
        elevation: selected ? 3 : 0,
        color: selected ? const Color(0xff16A34A) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
