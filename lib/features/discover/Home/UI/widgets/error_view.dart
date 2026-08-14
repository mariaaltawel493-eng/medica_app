import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry; // 🌟 أصبحت اختيارية لدعم الحالة الفارغة

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/search_result_not_found (2).png',
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(message, textAlign: TextAlign.center),

          // 🌟 لا يظهر الزر إلا إذا كان هناك حدث إعادة محاولة فعلي (حالة الخطأ)
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: Text("notification.retry".tr()),
            ),
          ],
        ],
      ),
    );
  }
}
