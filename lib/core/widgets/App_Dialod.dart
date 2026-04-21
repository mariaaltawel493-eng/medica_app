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

  const AppDialod({
    super.key,
    required this.title,
    required this.subtitle,
    this.type = DialogType.success,
  });

  @override
  State<AppDialod> createState() => _AppDialodState();
}

class _AppDialodState extends State<AppDialod> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    // تشغيل الاحتفال فور ظهور الديالوغ إذا كانت الحالة "نجاح"
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath, height: 160, width: 160),
                const SizedBox(height: 24),
                Text(
                  widget.title.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const AppLoadingIndicator(size: 50),
              ],
            ),
          ),
        ),

        // ويدجيت الاحتفال
        if (widget.type == DialogType.success)
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.blue,
              Colors.lightBlue,
              Colors.white,
            ], // ألوان تناسب تطبيقك
            numberOfParticles: 20,
          ),
      ],
    );
  }
}
