import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class MonitoringCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final String lastUpdated;
  final VoidCallback onAddTap;

  const MonitoringCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.lastUpdated,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkcardBackground
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🩸 أيقونة المؤشر مع خلفية دائرية خفيفة
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),

          // 📝 تفاصيل المؤشر الحيوية
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                // عرض القراءة الحالية مع الوحدة (مثال: 120/80 mmHg)
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.darktextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // وقت آخر تحديث
                Text(
                  "${"notification.last_update".tr()}: $lastUpdated",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode
                        ? AppColors.darktextSecondary.withOpacity(0.6)
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // ➕ زر إضافة قراءة جديدة (علامة بلس دائرية أنيقة)
          IconButton(
            onPressed: onAddTap,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darklightPirmary
                    : AppColors.lightPraimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
