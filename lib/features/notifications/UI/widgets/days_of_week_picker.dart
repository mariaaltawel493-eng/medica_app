import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class DaysOfWeekPicker extends StatefulWidget {
  final Function(List<String> selectedDays) onChanged;

  const DaysOfWeekPicker({super.key, required this.onChanged});

  @override
  State<DaysOfWeekPicker> createState() => _DaysOfWeekPickerState();
}

class _DaysOfWeekPickerState extends State<DaysOfWeekPicker> {
  // الأيام الافتراضية المحددة في التصميم لتبدأ الشاشة بشكل جميل
  final List<String> _selectedDays = ["Mon", "Wed", "Fri"];

  // قائمة أيام الأسبوع السبعة
  final List<String> _allDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Text(
          "Days of week".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AppColors.darktextSecondary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // صف الأزرار للأيام
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _allDays.map((day) {
            final isSelected = _selectedDays.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                });
                // إرسال الأيام المختارة للشاشة الرئيسية
                widget.onChanged(_selectedDays);
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  // لون المربع يتغير حسب الاختيار ليعطي شكل فيغما الأزرق
                  color: isSelected
                      ? (isDarkMode ? AppColors.darkprimary : AppColors.primary)
                      : (isDarkMode
                            ? Colors.white10
                            : Colors.black.withOpacity(0.03)),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  day.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black),
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
