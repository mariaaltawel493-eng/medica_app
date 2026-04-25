import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final String? imageUrl;
  final VoidCallback onEditImage;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    this.imageUrl,
    required this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        // منطقة الصورة مع زر التعديل
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: isDark
                  ? AppColors.darkcardBackground
                  : AppColors.cardBackground,
              child: imageUrl == null || imageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: isDark
                          ? AppColors.darktextSecondary
                          : AppColors.textSecondary,
                    )
                  : null,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : null,
            ),
            // زر التعديل الصغير (الأزرق)
            GestureDetector(
              onTap: onEditImage,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // الاسم
        Text(
          name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        // رقم الهاتف
        Text(
          phone,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darktextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
