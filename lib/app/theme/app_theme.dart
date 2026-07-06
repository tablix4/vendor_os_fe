import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.light,
  );
}