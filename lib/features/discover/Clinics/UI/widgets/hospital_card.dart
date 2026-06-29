import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class HospitalCard extends StatelessWidget {
  final String name;
  final String address;
  final String? logo;
  final int specializationsCount;
  final double rating;

  const HospitalCard({
    super.key,
    required this.name,
    required this.address,
    required this.logo,
    required this.specializationsCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              logo ?? '',
              width: 95,
              height: 95,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 95,
                  height: 95,
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 19, color: Colors.blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 17,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$specializationsCount Specializations',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 19, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
