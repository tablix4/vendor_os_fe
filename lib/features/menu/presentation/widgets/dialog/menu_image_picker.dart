import 'dart:io';

import 'package:flutter/material.dart';

class MenuImagePicker extends StatelessWidget {
  final File? image;

  final String? imageUrl;

  final VoidCallback onTap;

  const MenuImagePicker({
    super.key,
    required this.image,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.file(image!, fit: BoxFit.cover),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _placeholder();
          },
        ),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: Colors.green.shade50,
          child: const Icon(
            Icons.add_a_photo,
            color: Color(0xff16A34A),
            size: 34,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          "Upload Food Image",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        Text(
          "Tap to select image",
          style: TextStyle(color: Colors.grey.shade600),
        ),

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xff16A34A),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            "Choose Image",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
