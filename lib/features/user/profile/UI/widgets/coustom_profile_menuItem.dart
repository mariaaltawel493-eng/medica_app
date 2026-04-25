import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class CustomProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color; // للسماح بتغيير اللون مثل حالة Logout
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const CustomProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    // نعتمد على Theme.of لضمان التوافق مع Dark/Light تلقائياً
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: isSwitch ? null : onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        // يمكنك هنا التحكم في خلفية الأيقونة إذا أردتِ مثل التصميم
        child: Icon(
          icon,
          color:
              color ??
              (isDark ? AppColors.darktextPrimary : AppColors.textPrimary),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSwitch
          ? Switch.adaptive(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: AppColors.primary, // أو لون من ملف ألوانك
            )
          : Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
            ),
    );
  }
}
