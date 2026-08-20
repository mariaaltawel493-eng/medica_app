import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class TimeFrequencySelector extends StatefulWidget {
  final List<TimeOfDay>? initialTimes;
  final Function(List<TimeOfDay> selectedTimes, String foodRelation) onChanged;

  const TimeFrequencySelector({
    super.key,
    required this.onChanged,
    this.initialTimes,
  });

  @override
  State<TimeFrequencySelector> createState() => _TimeFrequencySelectorState();
}

class _TimeFrequencySelectorState extends State<TimeFrequencySelector> {
  // 🌟 تعديل 1: جعل قائمة الأوقات تبدأ فارغة لتتناسق مع شروط الحفظ
  late List<TimeOfDay> _selectedTimes = [];
  @override
  void initState() {
    super.initState();
    if (widget.initialTimes != null) {
      _selectedTimes = List.from(widget.initialTimes!);
    }
  }

  // أبقينا المتغير لتمريره افتراضياً للـ onChanged دون عرضه في الواجهة منعاً لضرب الكود
  final String _defaultFoodRelation = "after_meal";

  // 🌟 طريقة اختيار الوقت الجديدة: تفتح واجهة إدخال الأرقام مباشرة (Input Mode)
  Future<void> _pickTime(BuildContext context) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // 🌟 تعديل 2: جعل نافذة اختيار الوقت تفتح كـ لوحة مفاتيح (إدخال يدوي) مباشرة
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: isDarkMode ? AppColors.darkprimary : AppColors.primary,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primary: isDarkMode ? AppColors.darkprimary : AppColors.primary,
              surface: isDarkMode
                  ? AppColors.darkcardBackground
                  : AppColors.cardBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? AppColors.darkprimary : AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && !_selectedTimes.contains(pickedTime)) {
      setState(() {
        _selectedTimes.add(pickedTime);
      });
      widget.onChanged(_selectedTimes, _defaultFoodRelation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🕒 عنوان أوقات التذكير
        Text(
          "notification.Reminder Times".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AppColors.darktextSecondary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // عرض الأوقات المحددة على شكل Chips مع زر الإضافة (+)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedTimes.map((time) {
              return Chip(
                label: Text(
                  time.format(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: isDarkMode
                    ? Colors.white10
                    : Colors.black.withOpacity(0.04),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.redAccent,
                ),
                onDeleted: () {
                  // 🌟 تعديل 3: السماح بحذف العناصر حتى لو بقي عنصر واحد لتصفير القائمة بالكامل
                  setState(() {
                    _selectedTimes.remove(time);
                  });
                  widget.onChanged(_selectedTimes, _defaultFoodRelation);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide.none,
                ),
              );
            }).toList(),

            // زر إضافة وقت جديد (+)
            GestureDetector(
              onTap: () => _pickTime(context),
              child: Chip(
                avatar: Icon(
                  Icons.add,
                  size: 18,
                  color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
                ),
                label: Text(
                  "notification.Add Time".tr(),
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.darkprimary : AppColors.primary,
                  ),
                ),
                backgroundColor:
                    (isDarkMode ? AppColors.darkprimary : AppColors.primary)
                        .withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
