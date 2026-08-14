import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class CustomDurationPicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  // 🌟 تعديل 1: جعل الـ endDate يقبل null لتمريره بسلام لشاشة الحفظ
  final Function(DateTime startDate, DateTime? endDate) onDurationChanged;

  const CustomDurationPicker({
    super.key,
    required this.onDurationChanged,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<CustomDurationPicker> createState() => _CustomDurationPickerState();
}

class _CustomDurationPickerState extends State<CustomDurationPicker> {
  DateTime _startDate = DateTime.now();

  // 🌟 تعديل 2: تفريغ تاريخ النهاية الافتراضي ليكون فارغاً (null)
  DateTime? _endDate;
  @override
  void initState() {
    super.initState();
    if (widget.initialStartDate != null) {
      _startDate = widget.initialStartDate!;
    }
    if (widget.initialEndDate != null) {
      _endDate = widget.initialEndDate;
    }
  }

  // دالة اختيار التاريخ
  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? const ColorScheme.dark(
                    primary: AppColors.darkprimary,
                    surface: AppColors.darkscaffoldBackground,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primary,
                    surface: AppColors.scaffoldBackground,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // إذا أصبح تاريخ البدء بعد تاريخ النهاية (في حال كان هناك تاريخ نهاية محدد)
          if (_endDate != null && _startDate.isAfter(_endDate!)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
      widget.onDurationChanged(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Duration".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AppColors.darktextSecondary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 🟦 كارد تاريخ البداية (أزرق)
            Expanded(
              child: _buildDateCard(
                context: context,
                title: "Start Date".tr(),
                date: _startDate,
                cardColor: const Color(0xFF29B6F6),
                onTap: () => _pickDate(context, true),
              ),
            ),
            const SizedBox(width: 16),

            // 🟩 كارد تاريخ النهاية (أخضر)
            Expanded(
              child: _buildDateCard(
                context: context,
                title: "End Date".tr(),
                date: _endDate, // 🌟 يمرر هنا كـ DateTime?
                cardColor: const Color(0xFF66BB6A),
                onTap: () => _pickDate(context, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required BuildContext context,
    required String title,
    required DateTime? date, // 🌟 تعديل 3: استقبال التاريخ كقيمة اختيارية
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardColor.withOpacity(0.3), width: 1.2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: cardColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // 🌟 تعديل 4: عرض محتوى مخصص بناءً على إذا ما كان التاريخ محدد أم فارغ
            if (date != null) ...[
              Text(
                "${date.day}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMMM').format(date),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cardColor,
                ),
              ),
            ] else ...[
              // في حال لم يحدد المستخدم تاريخ النهاية بعد
              const SizedBox(height: 8),
              Icon(Icons.calendar_month_outlined, color: cardColor, size: 26),
              const SizedBox(height: 6),
              Text(
                "---", // يمكنك كتابة "إدراج تاريخ" أو إبقائها فارغة هكذا بشكل رمزي أنيق
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: cardColor.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
