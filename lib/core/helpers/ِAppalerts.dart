import 'package:flutter/material.dart';
import 'package:medica_app/core/widgets/App_Dialod.dart';

class AppAlerts {
  static void showResultDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DialogType type,
    VoidCallback? onSuccessFinished,
    VoidCallback? onRetry,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    // وظيفة لزر الإعادة
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // نمنع الإغلاق بالضغط العشوائي
      builder: (context) => AppDialod(
        title: title,
        subtitle: subtitle,
        type: type,

        showLoading: false,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
