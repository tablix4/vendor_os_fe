import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateOrderHeader extends StatelessWidget {
  const CreateOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: Text(
            "Create New Order",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
