import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';

class HomeProfileReminderBanner extends StatelessWidget {
  const HomeProfileReminderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.MedicalRecordsScreen);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(isDark ? 0.15 : 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.4), width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.report_problem_rounded,
                color: Colors.amber,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "complete_profile_banner".tr(),
                  style: TextStyle(
                    color: isDark ? Colors.amber[200] : Colors.amber[900],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? Colors.amber[200] : Colors.amber[900],
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
