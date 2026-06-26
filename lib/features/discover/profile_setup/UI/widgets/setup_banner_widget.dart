import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_button.dart';

class SetupBannerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const SetupBannerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1), // لون خفيف ومريح
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            "setup.banner_title".tr(), // سنضيف هذا في ملف الترجمة لاحقاً
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          AppButton(text: "setup.complete_now".tr(), onPressed: onTap),
        ],
      ),
    );
  }
}
