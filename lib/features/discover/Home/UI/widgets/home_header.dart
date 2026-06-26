import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String fullName;
  final String? profileImageUrl;
  final VoidCallback onNotificationPressed;
  final VoidCallback onQrCodePressed;

  const HomeHeader({
    super.key,
    required this.fullName,
    this.profileImageUrl,
    required this.onNotificationPressed,
    required this.onQrCodePressed,
  });

  String _getGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "home.good_morning";
    } else if (hour >= 12 && hour < 17) {
      return "home.good_afternoon";
    } else {
      return "home.good_evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // 1. الصورة الشخصية
        CircleAvatar(
          radius: 25,
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
          backgroundImage:
              profileImageUrl != null && profileImageUrl!.isNotEmpty
              ? NetworkImage(profileImageUrl!)
              : null,
          child: (profileImageUrl == null || profileImageUrl!.isEmpty)
              ? Icon(
                  Icons.person,
                  size: 26,
                  color: isDark
                      ? AppColors.darktextSecondary
                      : AppColors.textSecondary,
                )
              : null,
        ),
        const SizedBox(width: 12),

        // 2. نصوص الترحيب والاسم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreetingKey().tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darktextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fullName.isNotEmpty
                    ? fullName
                    : "User", // يعرض الاسم أو "User" كقيمة افتراضية
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darktextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // 3. زر التنبيهات
        IconButton(
          onPressed: onNotificationPressed,
          icon: Icon(
            Icons.notifications_none_outlined,
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            size: 28,
          ),
        ),

        // 4. زر الـ QR
        IconButton(
          onPressed: onQrCodePressed,
          icon: Icon(
            Icons.qr_code_scanner_outlined,
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            size: 28,
          ),
        ),
      ],
    );
  }
}
