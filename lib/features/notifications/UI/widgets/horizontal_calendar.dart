import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ستحتاجين لمكتبة intl لترتيب وتنسيق التواريخ بسهولة
import 'package:medica_app/core/theme/app_colors.dart';

class HorizontalCalendar extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelected;

  const HorizontalCalendar({super.key, required this.onDateSelected});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late DateTime _selectedDate;
  late List<DateTime> _currentWeekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateCurrentWeek();
  }

  // دالة لتوليد الأيام المحيطة بيومنا الحالي لعرضها في الشريط
  void _generateCurrentWeek() {
    final now = DateTime.now();
    // سنقوم بتوليد 7 أيام (3 أيام قبل اليوم الحالي، واليوم الحالي، و3 أيام بعده)
    _currentWeekDays = List.generate(
      7,
      (index) => now.add(Duration(days: index - 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _currentWeekDays.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final day = _currentWeekDays[index];
          final isSelected = DateUtils.isSameDay(day, _selectedDate);

          // تنسيق اسم اليوم والتاريخ (يدعم الـ Localization تلقائياً عبر intl)
          final dayName = DateFormat(
            'E',
            Localizations.localeOf(context).toString(),
          ).format(day).toUpperCase();
          final dayNumber = DateFormat('d').format(day);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
              // إخبار الشاشة الأم بالتاريخ الجديد لتقوم بتحديث الـ BLoC وجلب بيانات هذا اليوم
              widget.onDateSelected(day);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDarkMode ? AppColors.darkprimary : AppColors.primary)
                    : (isDarkMode
                          ? AppColors.darkcardBackground
                          : AppColors.lightPraimary),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode
                                ? AppColors.darktextSecondary
                                : AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
