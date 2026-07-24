import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_hr/core/auth/user_session_reset.dart';
import 'package:my_hr/core/storage/storage_service.dart';
import 'package:my_hr/features/category/presentation/providers/category_provider.dart';
import 'package:my_hr/features/profile/presentation/providers/profile_provider.dart';
import 'package:pinput/pinput.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';

import '../../data/models/send_otp_request.dart';
import '../../data/models/verify_otp_request.dart';
import '../../data/services/auth_service.dart';

import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../menu/presentation/providers/menu_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  final AuthService _authService = AuthService();

  bool loading = false;
  bool resendLoading = false;

  int seconds = 30;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // ------------------------------------------------------------
  // TIMER
  // ------------------------------------------------------------

  void startTimer() {
    timer?.cancel();

    seconds = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds <= 0) {
        timer.cancel();
        return;
      }

      if (mounted) {
        setState(() {
          seconds--;
        });
      }
    });
  }

  // ------------------------------------------------------------
  // CLEAR PREVIOUS USER STATE
  // ------------------------------------------------------------

  void _clearPreviousUserState() {
    // Dashboard
    ref.invalidate(dashboardProvider);
    ref.invalidate(dashboardFilterProvider);

    // Menu
    ref.invalidate(menuProvider);

    // Orders
    ref.invalidate(orderProvider);

    // Categories
    ref.invalidate(categoryProvider);

    // Profile
    ref.invalidate(profileProvider);
  }

  // ------------------------------------------------------------
  // VERIFY OTP
  // ------------------------------------------------------------

  Future<void> verifyOTP() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a valid OTP')));

      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final response = await _authService.verifyOtp(
        VerifyOtpRequest(email: widget.email, otp: otp),
      );

      if (!mounted) return;

      // ----------------------------------------------------------
      // NEW USER
      // ----------------------------------------------------------

      if (response.data.isNewUser) {
        // Very important:
        // New-user registration must not inherit the previous
        // authenticated user's Riverpod state.
        resetUserSessionProviders(ref);

        // Clear old authentication storage before establishing
        // the temporary registration session.
        await StorageService.clearAll();

        await StorageService.saveTempToken(response.data.tempToken!);

        if (!mounted) return;

        resetUserSessionProviders(ref);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/complete-profile');

        return;
      }

      // ----------------------------------------------------------
      // EXISTING USER
      // ----------------------------------------------------------
      // Clear anything from previous session.
      resetUserSessionProviders(ref);
      await StorageService.saveAccessToken(response.data.accessToken!);

      await StorageService.saveRefreshToken(response.data.refreshToken!);

      if (!mounted) return;

      // Providers recreated after here must use the new account.
      resetUserSessionProviders(ref);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
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

  // ------------------------------------------------------------
  // RESEND OTP
  // ------------------------------------------------------------

  Future<void> resendOTP() async {
    // User can resend only after timer reaches 0.
    if (seconds > 0) return;

    // Prevent multiple API calls.
    if (resendLoading) return;

    setState(() {
      resendLoading = true;
    });

    try {
      final response = await _authService.sendOtp(
        SendOtpRequest(email: widget.email),
      );

      if (!mounted) return;

      // Remove previously entered OTP.
      otpController.clear();

      // Start another 30-second countdown.
      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          resendLoading = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return AppPage(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const SizedBox(height: 30),

            const AppLogo(size: 70),

            const SizedBox(height: 35),

            const Text(
              'Verify Email',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            const Text(
              'Verification code sent to',
              style: TextStyle(color: Colors.grey),
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
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 35),

            Text(
              '00:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff16A34A),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: seconds == 0 && !resendLoading ? resendOTP : null,
              child: resendLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Resend OTP'),
            ),

            const SizedBox(height: 35),

            AppButton(
              text: 'Verify OTP',
              loading: loading,
              onPressed: verifyOTP,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
