import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';

import 'package:medica_app/features/notifications/medication/data/models/medication_reminder_model.dart';

class MedicationCard extends StatelessWidget {
  final MedicationReminderModel
  reminder; // 🎯 الكائن الكامل الممرر لشاشة التفاصيل
  final String medicineName;
  final String dosage;
  final String time;
  final String instruction; // مثل: قبل الأكل أو بعد الأكل
  final Color cardColor; // اللون المتناوب الممرر تلقائياً من الـ ListView
  final VoidCallback onSwiped;
  final bool isTaken; // لمنع كسر استدعاء الملف في الشاشات الأخرى

  const MedicationCard({
    super.key,
    required this.reminder,
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.instruction,
    required this.cardColor,
    required this.onSwiped,
    this.isTaken = false,
  });

  // 🎯 دالة مساعدة لتحويل الوقت وإضافة (صباحاً / مساءً) باللغة العربية
  String _formatTimeWithPeriod(String timeStr) {
    try {
      // تنظيف النص من أي فراغات أو لواحق قديمة
      String cleanTime = timeStr
          .toLowerCase()
          .replaceAll('am', '')
          .replaceAll('pm', '')
          .trim();
      List<String> parts = cleanTime.split(':');
      int hour = int.parse(parts[0]);
      String minutes = parts[1];

      // الفحص لمعرفة هل الوقت مساءً (يحتوي pm أو الساعة 12 فما فوق)
      if (timeStr.toLowerCase().contains('pm') || hour >= 12) {
        int displayHour = hour > 12 ? hour - 12 : hour;
        if (displayHour == 0) displayHour = 12; // ضبط الساعة 00 لتصبح 12
        return "$displayHour:$minutes مساءً";
      } else {
        int displayHour = hour == 0 ? 12 : hour;
        return "$displayHour:$minutes صباحاً";
      }
    } catch (e) {
      // في حال وجود صيغة نصية غريبة لا يمكن تحليلها، يعود الوقت الأصلي كما هو لضمان عدم تعطل التطبيق
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onSwiped();
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkcardBackground
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.medication, color: cardColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dosage,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.darktextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDarkMode
                            ? AppColors.darkprimary
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      // 🎯 التعديل هنا: قمنا بتمرير المتغير time داخل الدالة ليعرض التنسيق العربي
                      Text(
                        "${_formatTimeWithPeriod(time)} - $instruction",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppColors.darkprimary
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  color: isDarkMode
                      ? AppColors.darktextSecondary.withOpacity(0.5)
                      : AppColors.textTertiary,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.MedicineInformationScreen,
                      arguments: reminder,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: isDarkMode
                          ? AppColors.darktextSecondary.withOpacity(0.4)
                          : AppColors.textTertiary.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
