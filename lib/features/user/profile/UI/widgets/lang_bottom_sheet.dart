import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/user/settings/language/cubit/language_cubit.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        // بياخد لون الثيم تلقائياً من الـ MaterialApp
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // خط صغير فوق للزينة (Handle)
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "profile.choose_language".tr(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // خيار اللغة العربية
          _buildLanguageItem(
            context,
            title: "العربية",
            langCode: 'ar',
            icon: "🇸🇦", // أو أي أيقونة بتفضليها
          ),
          const Divider(), // خط فاصل بسيط
          // خيار اللغة الإنجليزية
          _buildLanguageItem(
            context,
            title: "English",
            langCode: 'en',
            icon: "🇺🇸",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context, {
    required String title,
    required String langCode,
    required String icon,
  }) {
    // كود اللغة الحالي لنعرف مين "المختار"
    bool isSelected = context.locale.languageCode == langCode;

    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        context.read<LanguageCubit>().ChangeLanguage(context, langCode);
        Navigator.pop(context); // إغلاق القائمة بعد الاختيار
      },
    );
  }
}
