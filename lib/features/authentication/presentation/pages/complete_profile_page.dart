import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/app_text_field.dart';

import '../../data/models/complete_profile_request.dart';
import '../../data/services/auth_service.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final shopController = TextEditingController();

  final AuthService _authService = AuthService();

  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    shopController.dispose();
    super.dispose();
  }

  Future<void> continuePressed() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      final tempToken = await StorageService.getTempToken();

      debugPrint("========== COMPLETE PROFILE ==========");
      debugPrint("TEMP TOKEN => $tempToken");

      if (tempToken == null || tempToken.isEmpty) {
        throw Exception("Session expired. Please login again.");
      }

      final response = await _authService.completeProfile(
        tempToken,
        CompleteProfileRequest(
          name: nameController.text.trim(),
          shopName: shopController.text.trim(),
        ),
      );

      debugPrint("PROFILE RESPONSE => ${response.message}");

      await StorageService.saveAccessToken(response.data.accessToken);

      await StorageService.saveRefreshToken(response.data.refreshToken);

      await StorageService.clearTempToken();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      context.go("/dashboard");
    } catch (e) {
      debugPrint("COMPLETE PROFILE ERROR => $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),

            const AppLogo(),

            const Text(
              "Complete Profile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tell us a little about yourself.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            AppTextField(
              controller: nameController,
              label: "Full Name",
              hint: "Harshad Patoliya",
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your full name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            AppTextField(
              controller: shopController,
              label: "Shop Name",
              hint: "Om Fast Food",
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter shop name";
                }
                return null;
              },
            ),

            const SizedBox(height: 35),

            AppButton(
              text: "Continue",
              loading: loading,
              onPressed: continuePressed,
            ),
          ],
        ),
      ),
    );
  }
}
