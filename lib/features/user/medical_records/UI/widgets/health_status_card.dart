import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class HealthStatusCard extends StatelessWidget {
  final List<dynamic>? chronicDiseases;
  final List<dynamic>? allergies;
  final List<dynamic>? currentMedications;

  final VoidCallback? onEdit;

  const HealthStatusCard({
    super.key,
    this.chronicDiseases,
    this.allergies,
    this.currentMedications,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final chronicList = chronicDiseases ?? [];
    final allergyList = allergies ?? [];
    final medicationList = currentMedications ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── الهيدر مع زر التعديل ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'medical.health_status'.tr().toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: isDark
                      ? AppColors.darktextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  // ✅ زر التعديل الجديد
                  if (onEdit != null)
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'medical.edit_info'.tr(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.health_and_safety_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── الأمراض المزمنة ──
          _buildSubCategory('medical.chronic_diseases'.tr().toUpperCase()),
          chronicList.isEmpty
              ? _buildEmptyState('medical.no_chronic_diseases'.tr(), isDark)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chronicList.map((disease) {
                    return _customChip(disease.toString(), true, isDark);
                  }).toList(),
                ),
          const SizedBox(height: 20),

          // ── الحساسية ──
          _buildSubCategory('medical.allergies'.tr().toUpperCase()),
          allergyList.isEmpty
              ? _buildEmptyState('medical.no_allergies'.tr(), isDark)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allergyList.map((allergy) {
                    return _customChip(allergy.toString(), false, isDark);
                  }).toList(),
                ),

          const SizedBox(height: 20),

          // ── الأدوية الحالية ──
          _buildSubCategory('medical.current_medications'.tr().toUpperCase()),
          medicationList.isEmpty
              ? _buildEmptyState('medical.no_medications'.tr(), isDark)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: medicationList.map((medication) {
                    return _customChip(medication.toString(), false, isDark);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildSubCategory(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white60 : Colors.black45,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _customChip(String label, bool isChronic, bool isDark) {
    final bgColor = isChronic
        ? (isDark ? AppColors.chronicChipDark : AppColors.chronicChipLight)
        : (isDark ? AppColors.allergyChipDark : AppColors.allergyChipLight);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.chipTextDark : AppColors.chipTextLight,
        ),
      ),
    );
  }

  Widget _buildMedicationItem(String name, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
