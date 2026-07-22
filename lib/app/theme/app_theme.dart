import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor:
        AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.white,
      error: AppColors.error,
    ),

    // Global loader color
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.border,
    ),

    // Global bottom navigation theme
    navigationBarTheme:
        NavigationBarThemeData(
      height: 75,
      backgroundColor: AppColors.white,

      indicatorColor:
          AppColors.primary.withValues(
        alpha: 0.12,
      ),

      iconTheme:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return const IconThemeData(
              color: AppColors.primary,
            );
          }

          return const IconThemeData(
            color: AppColors.grey,
          );
        },
      ),

      labelTextStyle:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }

          return const TextStyle(
            color: AppColors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        },
      ),
    ),

    // Button theme
    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            AppColors.white,
      ),
    ),

    // Text button theme
    textButtonTheme:
        TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor:
            AppColors.primary,
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme:
        OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor:
            AppColors.primary,
        side: const BorderSide(
          color: AppColors.primary,
        ),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor:
          AppColors.primary,
      foregroundColor:
          AppColors.white,
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.primary;
          }

          return null;
        },
      ),
    ),

    // Radio button theme
    radioTheme: RadioThemeData(
      fillColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.primary;
          }

          return AppColors.grey;
        },
      ),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.white;
          }

          return null;
        },
      ),
      trackColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.primary;
          }

          return null;
        },
      ),
    ),
  );
}