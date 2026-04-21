import 'package:flutter/material.dart';

class Appsnackbar {
  static void showError(BuildContext context, String message) {
    // أولاً: نمسح أي رسالة قديمة عشان ما يتراكموا
    ScaffoldMessenger.of(context).clearMaterialBanners();

    // ثانياً: نعرض البانر في الأعلى
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          // لازم يكون في زر إغلاق أو نتركه فاضي بس فلاتر بيطلبه
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );

    // ثالثاً: نخليه يختفي تلقائياً بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
