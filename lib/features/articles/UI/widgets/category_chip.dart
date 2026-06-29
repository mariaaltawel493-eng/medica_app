import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.darkcardBackground : Colors.white),
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (isDark ? AppColors.darktextPrimary : AppColors.primary),
          ),
        ),
      ),
    );
  }
}
