import 'package:flutter/material.dart';
import 'package:medica_app/core/helpers/%D9%90Appalerts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/widgets/App_Dialod.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // هذا هو "القفل" لضمان عدم التكرار
  bool _isDialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // نتحقق من الإشارة ومن أن الديالوج لم تُعرض بعد في هذه الجلسة
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == 'show_success_dialog' && !_isDialogShown) {
      _isDialogShown = true; // نغلق القفل فوراً

      // نستخدم التأخير البسيط (ملي ثانية) لضمان استقرار الواجهة
      Future.delayed(Duration.zero, () {
        AppAlerts.showResultDialog(
          context: context,
          title: "profile.congrats".tr(),
          subtitle: "profile.account_created".tr(),
          type: DialogType.success,
          onConfirm: () {
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pop();
              print("stamp:dialog should be closed now!");
            }
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الصفحة الرئيسية")),
      body: Center(
        child: AppButton(
          text: "Profile",
          onPressed: () {
            Navigator.pushNamed(context, Routes.ProfileScreen);
          },
        ),
      ),
    );
  }
}
