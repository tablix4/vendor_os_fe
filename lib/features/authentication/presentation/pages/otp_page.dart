import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/auth/user_session_reset.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_page.dart';

import '../../data/models/send_otp_request.dart';
import '../../data/models/verify_otp_request.dart';
import '../../data/services/auth_service.dart';

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

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();

    super.dispose();
  }

  // ============================================================
  // TIMER
  // ============================================================

  void startTimer() {
    timer?.cancel();

    if (mounted) {
      setState(() {
        seconds = 30;
      });
    } else {
      seconds = 30;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds <= 0) {
        timer.cancel();
        return;
      }

      if (!mounted) return;

      setState(() {
        seconds--;
      });
    });
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> verifyOTP() async {
    FocusScope.of(context).unfocus();

    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _showErrorMessage('Please enter a valid 6-digit OTP.');

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

      // ========================================================
      // NEW USER
      // ========================================================

      if (response.data.isNewUser) {
        // Remove Riverpod state belonging to any previous user.
        resetUserSessionProviders(ref);

        // Remove old authentication/session data.
        await StorageService.clearAll();

        // Store temporary token for profile completion.
        await StorageService.saveTempToken(response.data.tempToken!);

        if (!mounted) return;

        // Ensure all account-specific providers are recreated
        // for the new registration session.
        resetUserSessionProviders(ref);

        _showSuccessMessage(response.message);

        context.go('/complete-profile');

        return;
      }

      // ========================================================
      // EXISTING USER
      // ========================================================

      // Clear provider state from the previously logged-in user
      // before establishing the new authenticated session.
      resetUserSessionProviders(ref);

      // Important:
      // Clear old stored tokens/session before saving new tokens.
      await StorageService.clearAll();

      await StorageService.saveAccessToken(response.data.accessToken!);

      await StorageService.saveRefreshToken(response.data.refreshToken!);

      if (!mounted) return;

      // Providers created after this point will use the newly
      // authenticated user's access token.
      resetUserSessionProviders(ref);

      _showSuccessMessage(response.message);

      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<void> resendOTP() async {
    if (seconds > 0) return;

    if (resendLoading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      resendLoading = true;
    });

    try {
      final response = await _authService.sendOtp(
        SendOtpRequest(email: widget.email),
      );

      if (!mounted) return;

      // Old OTP should no longer remain in the input.
      otpController.clear();

      // Restart countdown only after successful API response.
      startTimer();

      _showSuccessMessage(response.message);
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          resendLoading = false;
        });
      }
    }
  }

  // ============================================================
  // SNACKBAR HELPERS
  // ============================================================

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 58,

      // Uses our centralized Poppins typography.
      textStyle: AppTextStyles.title.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xff0F172A),
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.6),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.40)),
      ),
    );

    return AppPage(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const SizedBox(height: 30),

            // ==================================================
            // LOGO
            // ==================================================
            const AppLogo(size: 70),

            const SizedBox(height: 34),

            // ==================================================
            // TITLE
            // ==================================================
            Text(
              'Verify Email',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DESCRIPTION
            // ==================================================
            Text(
              'We sent a 6-digit verification code to',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xff64748B),
              ),
            ),

            const SizedBox(height: 6),

            // ==================================================
            // EMAIL
            // ==================================================
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 36),

            // ==================================================
            // OTP INPUT
            // ==================================================
            Pinput(
              controller: otpController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofocus: false,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              onCompleted: (_) {
                if (!loading) {
                  verifyOTP();
                }
              },
            ),

            const SizedBox(height: 30),

            // ==================================================
            // TIMER
            // ==================================================
            if (seconds > 0) ...[
              Text('Resend code in', style: AppTextStyles.caption),

              const SizedBox(height: 5),

              Text(
                '00:${seconds.toString().padLeft(2, '0')}',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Text("Didn't receive the code?", style: AppTextStyles.caption),
            ],

            const SizedBox(height: 10),

            // ==================================================
            // RESEND OTP
            // ==================================================
            TextButton(
              onPressed: seconds == 0 && !resendLoading ? resendOTP : null,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                disabledForegroundColor: const Color(0xff94A3B8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: resendLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      'Resend OTP',
                      style: AppTextStyles.bodySemiBold.copyWith(
                        color: seconds == 0
                            ? AppColors.primary
                            : const Color(0xff94A3B8),
                      ),
                    ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // VERIFY BUTTON
            // ==================================================
            AppButton(
              text: 'Verify OTP',
              loading: loading,
              onPressed: verifyOTP,
            ),

            const SizedBox(height: 18),

            // ==================================================
            // CHANGE EMAIL
            // ==================================================
            TextButton(
              onPressed: loading || resendLoading
                  ? null
                  : () {
                      context.pop();
                    },
              child: Text(
                'Change Email Address',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
