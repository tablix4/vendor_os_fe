import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  final int totalItems;
  final int availableItems;
  final int unavailableItems;
  final VoidCallback onAdd;

  const MenuHeader({
    super.key,
    required this.totalItems,
    required this.availableItems,
    required this.unavailableItems,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xff16A34A), Color(0xff0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🍽 Menu Management",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Manage your restaurant menu easily",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  "Total",
                  totalItems.toString(),
                  Icons.restaurant_menu,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStat(
                  "Available",
                  availableItems.toString(),
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStat(
                  "Out",
                  unavailableItems.toString(),
                  Icons.cancel,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Menu Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
