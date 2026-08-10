import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/send_otp_request.dart';
import '../../data/services/auth_service.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool loading = false;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> continuePressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final response = await _authService.sendOtp(
        SendOtpRequest(email: emailController.text.trim()),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
      context.push("/otp", extra: emailController.text.trim());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const AppLogo(),
              const SizedBox(height: 40),
              Text('Welcome', style: AppTextStyles.display),
              const SizedBox(height: 10),
              Text(
                'Sign in to continue managing\nyour restaurant.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 50),
              AppTextField(
                controller: emailController,
                label: "Email Address",
                hint: "example@gmail.com",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              AppButton(
                text: "Continue",
                loading: loading,
                onPressed: continuePressed,
              ),
              const SizedBox(height: 25),
              const Text(
                "We'll send a verification\ncode to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 70),
              Text('Version 1.0.0', style: AppTextStyles.small),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
