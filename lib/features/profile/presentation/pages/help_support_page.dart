import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({
    super.key,
  });

  static const String _supportEmail =
      'tablix4@gmail.com';

  Future<void> _openEmail(
    BuildContext context,
  ) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'VendorOS Support Request',
      },
    );

    final bool launched =
        await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open email app.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        backgroundColor:
            AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: Text(
          'Help & Support',
          style:
              AppTextStyles.title.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            children: [
              _buildHeroSection(),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              _buildSupportBenefits(),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              _buildEmailSupportCard(
                context,
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              _buildBottomMessage(),

              const SizedBox(
                height: AppSpacing.lg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
            ),
            child: const Icon(
              Icons.support_agent,
              size: 44,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          Text(
            'We\'re Here to Help You!',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.title.copyWith(
              fontSize: 26,
              height: 1.2,
            ),
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            'Have questions, feedback, or need assistance? '
            'Our team is always ready to support you.',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.body.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBenefits() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _SupportBenefitItem(
              icon:
                  Icons.chat_bubble_outline,
              title: 'Quick\nSupport',
              description:
                  'We solve your queries quickly.',
            ),
          ),

          SizedBox(
            width: AppSpacing.sm,
          ),

          Expanded(
            child: _SupportBenefitItem(
              icon:
                  Icons.headset_mic_outlined,
              title: 'Friendly\nTeam',
              description:
                  'Our team is always happy to help.',
            ),
          ),

          SizedBox(
            width: AppSpacing.sm,
          ),

          Expanded(
            child: _SupportBenefitItem(
              icon:
                  Icons.verified_user_outlined,
              title: 'Reliable\nHelp',
              description:
                  'Count on us whenever you need.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSupportCard(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(
                alpha: 0.18,
              ),
            ),
            child: const Icon(
              Icons.email_outlined,
              size: 32,
              color: AppColors.white,
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Text(
            'Email Support',
            style:
                AppTextStyles.title.copyWith(
              fontSize: 22,
              color: AppColors.white,
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Text(
            'Have questions?\nReach us anytime at',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.body.copyWith(
              color: AppColors.white
                  .withValues(
                alpha: 0.85,
              ),
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Material(
            color: AppColors.white,
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
            child: InkWell(
              onTap: () {
                _openEmail(context);
              },
              borderRadius:
                  BorderRadius.circular(
                AppRadius.md,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      AppSpacing.lg,
                  vertical:
                      AppSpacing.md,
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color:
                          AppColors.primary,
                    ),

                    const SizedBox(
                      width:
                          AppSpacing.sm,
                    ),

                    Flexible(
                      child: Text(
                        _supportEmail,
                        style: AppTextStyles
                            .body
                            .copyWith(
                          color:
                              AppColors.primary,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: 18,
                color: AppColors.white
                    .withValues(
                  alpha: 0.85,
                ),
              ),

              const SizedBox(
                width: AppSpacing.sm,
              ),

              Flexible(
                child: Text(
                  'We typically respond within 24 hours.',
                  textAlign:
                      TextAlign.center,
                  style: AppTextStyles
                      .caption
                      .copyWith(
                    color: AppColors.white
                        .withValues(
                      alpha: 0.90,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMessage() {
    return Column(
      children: [
        const Icon(
          Icons.favorite_border,
          color: AppColors.primary,
          size: 28,
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          'Your success is our priority.',
          textAlign: TextAlign.center,
          style:
              AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(
          height: AppSpacing.xs,
        ),

        Container(
          width: 72,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
                BorderRadius.circular(
              100,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportBenefitItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SupportBenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                AppColors.primary.withValues(
              alpha: 0.10,
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        Text(
          title,
          textAlign: TextAlign.center,
          style:
              AppTextStyles.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          description,
          textAlign: TextAlign.center,
          style:
              AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: AppColors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}