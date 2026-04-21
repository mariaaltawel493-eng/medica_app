import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/widgets/Otp_fields.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_button.dart';

class RegisterOtpView extends StatefulWidget {
  const RegisterOtpView({super.key});

  @override
  State<RegisterOtpView> createState() => _RegisterOtpViewState();
}

class _RegisterOtpViewState extends State<RegisterOtpView> {
  final otpController = TextEditingController();

  // إعدادات العداد (Timer)
  Timer? _timer;
  int _start = 60;

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(); // تشغيل العداد فور فتح الشاشة
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء العداد عند إغلاق الشاشة لمنع استهلاك الذاكرة
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // تنسيق مربعات الـ OTP

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkcardBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
              listener: (context, state) {
                if (state is RegisterOtpsuccess) {
                  Navigator.pushNamed(context, 'regi_password');
                } else if (state is AuthBlocError) {
                  Appsnackbar.showError(context, state.message.tr());
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png",
                      height: 150,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Welcome to Medica!".tr(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darktextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We sent you a verification code".tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 50),

                    OtpFields(controller: otpController),

                    const SizedBox(height: 40),

                    TextButton(
                      onPressed: _start == 0
                          ? () {
                              // نبرمج إعادة الإرسال هنا لاحقاً
                              startTimer();
                            }
                          : null,
                      child: Text(
                        _start == 0
                            ? "Resend Code".tr()
                            : "${"Didn't receive a code? Resend in".tr()} : ${_start}s",
                        style: TextStyle(
                          fontSize: 14,
                          color: _start == 0 ? AppColors.primary : Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                    if (state is AuthBlocLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      AppButton(
                        text: "Continue".tr(),
                        onPressed: () {
                          if (otpController.text.length == 6) {
                            context.read<AuthBlocBloc>().add(
                              RegisterOtpVerified(
                                otpController.text,
                                type: "register",
                              ),
                            );
                          } else {
                            Appsnackbar.showError(
                              context,
                              'Please enter the full 6-digit code'.tr(),
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
