import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/notifications/UI/pages/create_new_medicine_screen.dart';

import 'package:medica_app/features/notifications/medication/data/models/medication_reminder_model.dart';

class MedicineInformationScreen extends StatelessWidget {
  final MedicationReminderModel reminder;

  const MedicineInformationScreen({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎯 الحل: تحويل الـ String القادم من الباكيند إلى DateTime قبل عمل التنسيق
    String startDateText = "--";
    String endDateText = "--";

    if (reminder.startDate.isNotEmpty) {
      final parsedStart = DateTime.tryParse(reminder.startDate);
      if (parsedStart != null) {
        startDateText = DateFormat('d MMMM').format(parsedStart);
      }
    }

    if (reminder.endDate != null && reminder.endDate!.isNotEmpty) {
      final parsedEnd = DateTime.tryParse(reminder.endDate!);
      if (parsedEnd != null) {
        endDateText = DateFormat('d MMMM').format(parsedEnd);
      }
    }

    final String durationText = "From $startDateText To $endDateText";

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkcardBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "notification.Information".tr(),
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darktextPrimary
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟦 أيقونة الدواء الكبيرة في الأعلى
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF29B6F6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.medication,
                  color: Color(0xFF29B6F6),
                  size: 55,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📝 اسم الدواء
            _buildInfoSection(
              context,
              "notification.Medicine Name".tr(),
              reminder.medicationName,
              isHeader: true,
            ),
            const SizedBox(height: 16),

            // 🕒 أوقات أخذ الدواء
            if (reminder.reminderTimes.isNotEmpty) ...[
              Text(
                "notification.Time".tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode
                      ? AppColors.darktextSecondary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reminder.reminderTimes.map((time) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkprimary.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkprimary
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // 💊 الجرعة
            _buildInfoSection(
              context,
              "notification.Dosage".tr(),
              reminder.dosage ?? "notification.as_directed".tr(),
            ),
            const SizedBox(height: 16),

            // 🍽️ طريقة الاستخدام (ملاحظات الأكل)
            _buildInfoSection(
              context,
              "notification.Applying".tr(),
              reminder.notes != null && reminder.notes!.isNotEmpty
                  ? reminder.notes!
                  : "--",
            ),
            const SizedBox(height: 16),

            // 📅 المدة الزمنية
            _buildInfoSection(
              context,
              "notification.Duration".tr(),
              durationText,
            ),

            const Spacer(),

            // 🌟 زر تعديل الجدول
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: AppButton(
                text: "notification.Change Schedule".tr(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateNewMedicineScreen(medicineToEdit: reminder),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String value, {
    bool isHeader = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode
                ? AppColors.darktextSecondary
                : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isHeader ? 20 : 15,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? AppColors.darktextPrimary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
