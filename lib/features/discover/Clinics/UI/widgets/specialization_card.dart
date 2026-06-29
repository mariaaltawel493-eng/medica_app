import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class SpecializationCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecializationCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkcardBackground
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.medical_services, color: AppColors.primary),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darktextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
