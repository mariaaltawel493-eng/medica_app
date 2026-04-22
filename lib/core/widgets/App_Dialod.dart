import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';

enum DialogType { success, error }

class AppDialod extends StatefulWidget {
  final String title;
  final String subtitle;
  final DialogType type;
  final bool showLoading;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppDialod({
    super.key,
    required this.title,
    required this.subtitle,
    this.type = DialogType.success,
    this.showLoading = true,
    this.onConfirm,
    this.onCancel,
  });

  @override
  State<AppDialod> createState() => _AppDialodState();
}

class _AppDialodState extends State<AppDialod> {
  late ConfettiController _confettiController;
  int selectedButtonIndex =
      -1; // -1: لا يوجد ضغط، 0: الزر الأول، 1: الزر الثاني

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    if (widget.type == DialogType.success) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String imagePath = widget.type == DialogType.success
        ? "assets/images/password_successful.png"
        : "assets/images/appointment_failed.png";

    return Stack(
      alignment: Alignment.center,
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ), // قللنا الـ vertical padding شوي
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: 140,
                  width: 140,
                ), // صغرنا الصورة شوي للتناسق
                const SizedBox(height: 20),
                Text(
                  widget.title.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22, // صغرنا الخط شوي
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),

                if (widget.showLoading) ...[
                  const SizedBox(height: 24),
                  const AppLoadingIndicator(size: 40),
                ],

                // قسم الأزرار التفاعلية
                if (widget.onConfirm != null || widget.onCancel != null) ...[
                  const SizedBox(height: 28),
                  _buildInteractiveButton(
                    index: 0,
                    text: "validation.again".tr(),
                    onTap: widget.onConfirm,
                  ),
                  const SizedBox(height: 10), // مسافة أصغر بين الزرين
                  _buildInteractiveButton(
                    index: 1,
                    text: "validation.cancel".tr(),
                    onTap: widget.onCancel ?? () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),
        ),

        if (widget.type == DialogType.success)
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.blue, Colors.lightBlue, Colors.white],
            numberOfParticles: 20,
          ),
      ],
    );
  }

  // الدالة السحرية لتنسيق الأزرار حسب الثيم
  Widget _buildInteractiveButton({
    required int index,
    required String text,
    VoidCallback? onTap,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = selectedButtonIndex == index;

    // تحديد الألوان بناءً على حالة الضغط والثيم (مطابق للفيفما)
    Color bgColor;
    Color textColor;

    if (isSelected) {
      bgColor = AppColors.primary; // أزرق عند الاختيار
      textColor = Colors.white;
    } else {
      // الحالة العادية (بدون ضغط)
      bgColor = isDark
          ? const Color(0xFF35383F) // رمادي غامق جداً للدارك مود (Cancel)
          : const Color(0xFFE9F0FF); // سماوي فاتح جداً للايت مود (Cancel)

      textColor = isDark
          ? Colors
                .white // أبيض في الدارك مود
          : AppColors.primary; // أزرق في اللايت مود
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => selectedButtonIndex = index),
      onTapUp: (_) {
        setState(() => selectedButtonIndex = -1);
        if (onTap != null) onTap();
      },
      onTapCancel: () => setState(() => selectedButtonIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14), // حجم أصغر للزر
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
