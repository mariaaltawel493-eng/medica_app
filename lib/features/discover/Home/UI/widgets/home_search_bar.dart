import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap, // ينقل المستخدم عند الضغط على أي مكان في الحقل
      child: Container(
        height: 52, // الارتفاع القياسي المتناسق مع الفيجما
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // تغيير لون الخلفية تلقائياً حسب الثيم (فاتح أو داكن)
          color: isDark ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(
            16,
          ), // زوايا دائرية ناعمة تطابق التصميم
        ),
        child: Row(
          children: [
            // 1. أيقونة البحث في البداية
            Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 22,
            ),
            const SizedBox(width: 12),

            // 2. النص التلميحي المترجم (يأخذ مساحة الحقل بالكامل)
            Expanded(
              child: Text(
                "home.search_hint"
                    .tr(), // مفتاح الترجمة الذي أضفناه في الـ JSON
                style: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  fontSize: 15,
                ),
              ),
            ),

            // 3. أيقونة الفلترة في النهاية (تطابق شكل الفيجما تماماً)
            Icon(
              Icons.tune_rounded, // شكل هندسي أنيق للفلتر والـ Sliders
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
