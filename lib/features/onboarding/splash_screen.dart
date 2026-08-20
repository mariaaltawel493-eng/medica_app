import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart'; // تأكدي من استيراد الـ ApiService
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // تعريف الـ ApiService لاستخدامه في الفحص
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkNavigationLogic();
  }

  Future<void> _checkNavigationLogic() async {
    // 1. عرض اللوجو لمدة ثانيتين لإعطاء هوية للتطبيق
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 2. قراءة البيانات المحلية (التوكن وحالة الأونبوردينج)
    String? token = await SharedPrefHelper.getUserToken();
    bool onboardingSeen =
        await SharedPrefHelper.getData('onboarding_seen') ?? false;

    print("DEBUG: Splash Token -> $token");

    // 3. منطق التوجيه
    if (token != null && token.isNotEmpty) {
      try {
        // فحص حي لصلاحية التوكن عبر طلب بيانات البروفايل

        // إذا نجح الطلب، نتوجه للهوم
        if (mounted) Navigator.pushReplacementNamed(context, Routes.MainScreen);
      } catch (e) {
        //في حال منتهي الصلاحية التوكن
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.LoginScreen);
        }
      }
    } else if (onboardingSeen) {
      // إذا لم يوجد توكن ولكن الأونبوردينج شوهد سابقاً
      Navigator.pushReplacementNamed(context, Routes.LoginScreen);
    } else {
      // مستخدم جديد تماماً
      Navigator.pushReplacementNamed(context, Routes.OnboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  "onboarding.app_name".tr(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            const AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
