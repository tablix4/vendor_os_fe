import 'package:flutter/material.dart';

class CreateOrderSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  const CreateOrderSearch({super.key, required this.onChanged, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search menu items...',

        hintStyle: const TextStyle(color: Color(0xff94A3B8), fontSize: 14),

        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xff64748B)),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff16A34A), width: 1.5),
        ),
      ),
    );
  }
}
