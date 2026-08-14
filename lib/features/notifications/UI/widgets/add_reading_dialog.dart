import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class AddReadingDialog extends StatefulWidget {
  final String title;
  final String unit;
  final Function(String value) onSave;

  const AddReadingDialog({
    super.key,
    required this.title,
    required this.unit,
    required this.onSave,
  });

  @override
  State<AddReadingDialog> createState() => _AddReadingDialogState();
}

class _AddReadingDialogState extends State<AddReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDarkMode
          ? AppColors.darkcardBackground
          : AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "${"notification.add_new_reading".tr()} (${widget.title})",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? AppColors.darktextPrimary : AppColors.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _valueController,
          keyboardType:
              TextInputType.text, // يدعم النصوص والأرقام مثل ضغط الدم 120/80
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darktextPrimary
                : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: "notification.enter_value".tr(),
            hintStyle: TextStyle(
              color: isDarkMode
                  ? AppColors.darktextSecondary.withOpacity(0.5)
                  : AppColors.textTertiary,
            ),
            suffixText: widget.unit,
            suffixStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darktextSecondary.withOpacity(0.3)
                    : AppColors.textSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "notification.field_required".tr();
            }
            return null;
          },
        ),
      ),
      actions: [
        // زر الإلغاء
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "notification.cancel".tr(),
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darktextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        // زر الحفظ الأزرق المميّز
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(_valueController.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode
                ? AppColors.darkprimary
                : AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "notification.save".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
