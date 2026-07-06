import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_text_field.dart';

class CustomerInfoSection extends StatelessWidget {
  final TextEditingController customerNameController;
  final TextEditingController customerPhoneController;

  const CustomerInfoSection({
    super.key,
    required this.customerNameController,
    required this.customerPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customer Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        AppTextField(
          controller: customerNameController,
          label: "Customer Name",
          hint: "Walk-in Customer",
          keyboardType: TextInputType.name,
        ),

        const SizedBox(height: 16),

        AppTextField(
          controller: customerPhoneController,
          label: "Customer Phone",
          hint: "9876543210",
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
