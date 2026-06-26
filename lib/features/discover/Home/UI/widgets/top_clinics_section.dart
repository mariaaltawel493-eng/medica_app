import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/Home/data/models/topclinic_model.dart';

class TopClinicsSection extends StatelessWidget {
  final List<TopClinicModel> clinics;

  const TopClinicsSection({super.key, required this.clinics});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (clinics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الرأس (العنوان وزر رؤية الكل)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "home.top_clinics".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darktextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "home.see_all".tr(),
                style: TextStyle(
                  color: isDark ? AppColors.darkprimary : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 💡 التعديل هنا: حاوية بارتفاع ثابت لتمكين السكرول الأفقي
        SizedBox(
          height: 130, // هذا هو الارتفاع الذي يحتل مكان العيادات
          child: ListView.separated(
            scrollDirection: Axis.horizontal, // السكرول أصبح أفقياً
            physics: const BouncingScrollPhysics(),
            itemCount: clinics.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final clinic = clinics[index];

              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 280, // عرض محدد للكارد الواحد
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkcardBackground
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // لوجو العيادة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 75,
                          height: 75,
                          color: isDark
                              ? AppColors.darkscaffoldBackground
                              : AppColors.scaffoldBackground,
                          child: clinic.logo != null && clinic.logo!.isNotEmpty
                              ? Image.network(
                                  clinic.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.local_hospital,
                                        size: 35,
                                        color: AppColors.textTertiary,
                                      ),
                                )
                              : const Icon(
                                  Icons.local_hospital,
                                  size: 35,
                                  color: AppColors.textTertiary,
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // تفاصيل العيادة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              clinic.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darktextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // العنوان
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    clinic.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? AppColors.darktextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // التخصصات والتقييم
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${clinic.specializationsCount} ${'home.specializations'.tr()}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.darkprimary
                                        : AppColors.primary,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    Text(
                                      clinic.averageRating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppColors.darktextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
