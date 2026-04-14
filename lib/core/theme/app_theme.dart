import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // 1. ثيم الوضع الفاتح (Light Mode)
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    cardColor: AppColors.cardBackground,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      centerTitle: true,
    ),
  );

  // 2. ثيم الوضع الغامق (Dark Mode)
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkprimary,
    scaffoldBackgroundColor: AppColors.darkscaffoldBackground,
    cardColor: AppColors.darkcardBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darktextPrimary),
    ),
  );
}
