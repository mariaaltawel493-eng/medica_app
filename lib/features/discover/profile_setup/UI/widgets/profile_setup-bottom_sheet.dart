import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart'; // 🔥 استيراد الهيلبر للحفظ المحلي

class ProfileSetupBottomSheet extends StatelessWidget {
  const ProfileSetupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔥 تغليف الشيت بـ PopScope لمنع زر رجوع الهاتف من إغلاقها بدون اختيار
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkscaffoldBackground
              : AppColors.scaffoldBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض السحب العلوي
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // الصورة التوضيحية
            Image.asset(
              'assets/images/Submit Request (1) 2 (1).png',
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.medical_information_outlined,
                  size: 60,
                  color: AppColors.primary,
                );
              },
            ),
            const SizedBox(height: 24),

            // العنوان
            Text(
              "profile_setup.welcome_title".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.darktextPrimary
                    : AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // الوصف
            Text(
              "profile_setup.welcome_desc".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.darktextSecondary
                    : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // زر أكمل الآن
            AppButton(
              text: "profile_setup.complete_now".tr(),
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                ); // إغلاق الشيت وتمرير false لأن المستخدم لم يضغط تذكير لاحقاً
                Navigator.pushNamed(context, Routes.MedicalRecordsScreen);
              },
            ),
            const SizedBox(height: 12),

            // زر تذكيري لاحقاً
            TextButton(
              onPressed: () async {
                // 🔥 1. حفظ الحالة في الذاكرة المحلية بشكل دائم
                await SharedPrefHelper.setRemindLater(true);

                // 🔥 2. إغلاق الشيت وتمرير true ليعرف الهوم سكرين فوراً ويظهر البانر بدون ريلود
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(
                "profile_setup.remind_later".tr(),
                style: TextStyle(
                  color: isDark ? AppColors.darkprimary : AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
