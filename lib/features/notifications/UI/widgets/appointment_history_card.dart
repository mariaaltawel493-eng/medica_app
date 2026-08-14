import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class AppointmentHistoryCard extends StatelessWidget {
  final String dateDay; // رقم اليوم (مثال: 10)
  final String dateMonth; // اسم الشهر (مثال: October)
  final String clinicName; // اسم العيادة/التخصص (مثال: General Care)
  final String doctorName; // اسم الطبيب
  final String time; // وقت الموعد (مثال: 9:30 AM)
  final String
  status; // الحالة: 'upcoming', 'completed', 'canceled_by_secretary', 'canceled_by_patient'

  const AppointmentHistoryCard({
    super.key,
    required this.dateDay,
    required this.dateMonth,
    required this.clinicName,
    required this.doctorName,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // تحديد الألوان والنصوص بناءً على حالة الموعد المخصصة في السيستم عندكِ
    Color statusColor;
    String statusText;
    bool showCancelButton = false;

    if (status == 'completed') {
      statusColor = const Color(0xFF4CAF50); // أخضر
      statusText = "Completed".tr();
    } else if (status == 'canceled_by_secretary') {
      statusColor = const Color(0xFFE57373); // أحمر
      statusText = "Canceled by Secretary".tr();
    } else if (status == 'canceled_by_patient') {
      statusColor = Colors.orange;
      statusText = "Canceled by You".tr();
    } else {
      statusColor = AppColors.primary; // أزرق للمواعيد القادمة
      statusText = "Upcoming".tr();
      showCancelButton = true; // المريض يقدر يلغي فقط لو الموعد قادم
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تثبيت النوع دائماً ليكون "زيارة العيادة" كما اتفقتِ معي
          Text(
            "Clinic Visit".tr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppColors.darktextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // الصف الرئيسي (التاريخ الكبير + تفاصيل العيادة + شارة الحالة)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التاريخ على اليسار
              Column(
                children: [
                  Text(
                    dateDay,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    dateMonth.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppColors.darktextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // تفاصيل الموعد بالمنتصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinicName.tr(),
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
                      doctorName,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),

              // شارة الحالة الذكية
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Divider(height: 1, thickness: 0.5, color: Colors.white10),
          const SizedBox(height: 12),

          // السطر السفلي (وقت الموعد التذكيري + أزرار التحكم الاجرائية)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // عرض الوقت (تذكير: الموعد بعد ساعة مثلاً)
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
