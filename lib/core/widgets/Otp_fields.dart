import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class OtpFields extends StatelessWidget {
  final TextEditingController controller;

  const OtpFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : AppColors.cardBackground,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
