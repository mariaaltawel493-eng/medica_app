import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class VitalInfoCard extends StatelessWidget {
  final String? bloodType;
  final String? address;
  final String? emergencyContact;
  final String? phone;
  final VoidCallback onEdit;

  const VitalInfoCard({
    super.key,
    this.bloodType,
    this.address,
    this.emergencyContact,
    this.phone,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20), // Padding شامل لكل الكرت
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
          // 1. العنوان العلوي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'medical.vital_info'.tr(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: isDark
                      ? AppColors.darktextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.water_drop_outlined,
                size: 25,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 2. المحتوى (فصيلة الدم والبيانات)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    bloodType ?? "--",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoLabel("medical.address".tr()),
                    _buildInfoValue(address ?? "--", isDark),
                    const SizedBox(height: 12),
                    _buildInfoLabel("medical.emergency_contact".tr()),
                    _buildInfoValue(emergencyContact ?? "--", isDark),
                    const SizedBox(height: 8),
                    // أضفنا كلمة PHONE هنا كما طلبتِ
                    _buildInfoLabel("medical.phone".tr()),
                    _buildInfoValue(phone ?? "--", isDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. الزر بشكل منفصل (Floating-like style)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: Text(
                "medical.edit_info".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B4C7E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInfoValue(String value, bool isDark) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
      ),
    );
  }
}
