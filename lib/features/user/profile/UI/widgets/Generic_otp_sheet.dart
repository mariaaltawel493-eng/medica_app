import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/core/widgets/Otp_fields.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';

void showGenericOtpSheet({
  required BuildContext context,
  String? newPhone,
  String? newPassword,
  String? confirmPassword,
  required bool isPassword,

  required ProfileBlocBloc profileBloc,
}) {
  // تعريف متغيرات التايمر والـ Controller خارج الـ Builder
  int start = 60;
  Timer? timer;
  final TextEditingController sheetOtpController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          // دالة تشغيل التايمر وتحديث حالة الـ Sheet فقط
          void startSheetTimer() {
            start = 60;
            timer?.cancel();
            timer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (start == 0) {
                if (context.mounted) setSheetState(() => t.cancel());
              } else {
                if (context.mounted) setSheetState(() => start--);
              }
            });
          }

          // تشغيل التايمر عند أول بناء للشيت
          if (timer == null || !timer!.isActive && start == 60) {
            startSheetTimer();
          }

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkscaffoldBackground
                  : AppColors.scaffoldBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 24,
              right: 24,
              top: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "otp.title".tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  isPassword
                      ? "otp.sent_code".tr()
                      : "${"otp.sent_to".tr()} $newPhone",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // استخدام الـ Widget الجاهزة تبعك
                OtpFields(controller: sheetOtpController),

                const SizedBox(height: 30),

                // منطق الـ Resend
                TextButton(
                  onPressed: start == 0
                      ? () {
                          startSheetTimer();
                          // إعادة إرسال الـ OTP عن طريق البلوك
                          profileBloc.add(
                            sendUpdatePhoneOtpEvent(
                              type: isPassword
                                  ? 'password_change'
                                  : 'phone_update',
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    start == 0
                        ? "otp.resend_button".tr()
                        : "${"otp.resend_text".tr()} ${start}s",
                    style: TextStyle(
                      color: start == 0 ? AppColors.primary : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // زر التأكيد (Verify)
                BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                  builder: (context, state) {
                    if (state is UpdateProfileLoding) {
                      return const Center(child: AppLoadingIndicator());
                    }
                    return AppButton(
                      text: "otp.verify_button".tr(),
                      onPressed: () {
                        if (sheetOtpController.text.length == 6) {
                          if (isPassword) {
                            profileBloc.add(
                              ChangePasswordEvent(
                                sheetOtpController.text.trim(),
                                newPassword!,
                                confirmPassword!,
                              ),
                            );
                          } else {
                            profileBloc.add(
                              verifyAndUpdatePhoneEvent(
                                newPhone!,
                                sheetOtpController.text.trim(),
                              ),
                            );
                          }
                        } else {
                          Appsnackbar.showError(
                            context,
                            'otp.error_incomplete'.tr(),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  ).then((_) {
    timer?.cancel();
    sheetOtpController.dispose();
  });
}
