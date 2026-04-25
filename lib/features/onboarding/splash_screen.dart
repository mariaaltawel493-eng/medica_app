import 'dart:async';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // نغير الميثود لـ checkLogic بدل Timer عادي
    _checkNavigationLogic();
  }

  Future<void> _checkNavigationLogic() async {
    // 1. استني 3 ثواني عشان المستخدم يشوف اللوجو
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 2. شيكي على التوكن باستخدام الهيلبر تبعك
    // ملاحظة: استعملنا await لأن ميثود getUserToken هي Future
    String? token = await SharedPrefHelper.getUserToken();

    // 3. شيكي على الأونبوردينج (يفضل تضيفي مفتاح له بالهيلبر)
    // رح نفترض إن اسم المفتاح 'onboarding_seen'
    bool onboardingSeen =
        await SharedPrefHelper.getData('onboarding_seen') ?? false;

    // 4. اتخاذ القرار:
    if (token != null && token.isNotEmpty) {
      // المستخدم مسجل دخول وعنده توكن -> على الهوم دغري
      Navigator.pushReplacementNamed(context, '/home');
    } else if (onboardingSeen) {
      // شاف الأونبوردينج بس مو مسجل دخول -> على اللوجن
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // أول مرة يفتح التطبيق -> على الأونبوردينج
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

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
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png",

                    fit: BoxFit.contain,
                  ),
                ),
                //SizedBox(height: 5),
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
            const SizedBox(height: 180),
            AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
