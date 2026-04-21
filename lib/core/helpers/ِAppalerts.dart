import 'package:flutter/material.dart';
import 'package:medica_app/core/widgets/App_Dialod.dart';

class AppAlerts {
  static void showResultDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DialogType type,
    VoidCallback? onSuccessFinished,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AppDialod(title: title, subtitle: subtitle, type: type),
    );

    if (type == DialogType.success) {
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          if (onSuccessFinished != null) {
            onSuccessFinished();
          }
        }
      });
    }
  }
}
