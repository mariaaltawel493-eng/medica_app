import 'package:flutter/material.dart';
import 'package:medica_app/core/widgets/App_Dialod.dart';

class AppAlerts {
  static void showResultDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DialogType type,
    VoidCallback? onSuccessFinished,
    VoidCallback? onRetry, // وظيفة لزر الإعادة
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // نمنع الإغلاق بالضغط العشوائي
      builder: (context) => AppDialod(
        title: title,
        subtitle: subtitle,
        type: type,
        // في النجاح: لا أزرار (إغلاق تلقائي) ونظهر الأنميشن
        // في الخطأ: نظهر الأزرار ونخفي أنميشن النقاط (لأنه خطأ وليس تحميل)
        showLoading: type == DialogType.success,
        onConfirm: type == DialogType.error
            ? (onRetry ?? () => Navigator.pop(context))
            : null,
        onCancel: type == DialogType.error
            ? () => Navigator.pop(context)
            : null,
      ),
    );

    // المنطق الخاص بالاختفاء التلقائي فقط للنجاح
    if (type == DialogType.success) {
      Future.delayed(const Duration(seconds: 4), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // إغلاق الديالوغ
          if (onSuccessFinished != null) {
            onSuccessFinished(); // الانتقال للصفحة التالية
          }
        }
      });
    }
  }
}
