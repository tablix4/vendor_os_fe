import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_hr/core/storage/storage_service.dart';
import 'package:pinput/pinput.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';

import '../../data/models/verify_otp_request.dart';
import '../../data/services/auth_service.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  final AuthService _authService = AuthService();

  bool loading = false;

  int seconds = 30;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    seconds = 30;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds == 0) {
          timer.cancel();
        } else {
          if (mounted) {
            setState(() {
              seconds--;
            });
          }
        }
      },
    );
  }

  Future<void> verifyOTP() async {
    if (otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid OTP"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final response = await _authService.verifyOtp(
        VerifyOtpRequest(
          email: widget.email,
          otp: otpController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      if (response.data.isNewUser) {
        await StorageService.saveTempToken(
    response.data.tempToken!);

context.go("/complete-profile");
      } else {
        await StorageService.saveAccessToken(
    response.data.accessToken!);

await StorageService.saveRefreshToken(
    response.data.refreshToken!);

context.go("/dashboard");
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
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
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
    );

    return AppPage(
      child: Column(
        children: [
          const SizedBox(height: 30),

          const AppLogo(size: 70),

          const SizedBox(height: 35),

          const Text(
            "Verify Email",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Verification code sent to",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            widget.email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff16A34A),
            ),
          ),

          const SizedBox(height: 40),

          Pinput(
            controller: otpController,
            length: 6,
            defaultPinTheme: defaultPinTheme,
          ),

          const SizedBox(height: 35),

          Text(
            "00:${seconds.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff16A34A),
            ),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: seconds == 0
                ? () {
                    // TODO
                    // Call Send OTP API Again
                    startTimer();
                  }
                : null,
            child: const Text("Resend OTP"),
          ),

          const SizedBox(height: 35),

          AppButton(
            text: "Verify OTP",
            loading: loading,
            onPressed: verifyOTP,
          ),
        ],
      ),
    );
  }
}