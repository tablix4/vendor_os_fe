import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {

  final TextEditingController controller;

  final String label;

  final String hint;

  final TextInputType keyboardType;

  final String? Function(String?)? validator;

  const AppTextField({

    super.key,

    required this.controller,

    required this.label,

    required this.hint,

    required this.keyboardType,

    this.validator,

  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: controller,

      validator: validator,

      keyboardType: keyboardType,

      decoration: InputDecoration(

        labelText: label,

        hintText: hint,

        prefixIcon: const Icon(Icons.email_outlined),

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,

        ),

        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide(

            color: Colors.grey.shade300,

          ),

        ),

        focusedBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(

            color: Color(0xff16A34A),

            width: 2,

          ),

        ),

      ),

    );

  }

}