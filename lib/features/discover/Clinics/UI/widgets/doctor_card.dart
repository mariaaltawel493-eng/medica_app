import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class DoctorCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String name;
  final String specialization;
  final double rating;
  final double consultationFee;
  final String? profile;

  const DoctorCard({
    this.onTap,
    super.key,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.consultationFee,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkcardBackground
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: profile != null
                  ? Image.network(
                      profile!.trim(),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, size: 40),
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/profile.jpg',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    specialization,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${consultationFee.toInt()} SYP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
