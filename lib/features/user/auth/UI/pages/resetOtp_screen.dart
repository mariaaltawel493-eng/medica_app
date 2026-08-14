import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/Otp_fields.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class ResetOtpScreen extends StatefulWidget {
  const ResetOtpScreen({super.key});

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  final otpController = TextEditingController();
  Timer? _timer;
  int _start = 60;

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        if (mounted) setState(() => timer.cancel());
      } else {
        if (mounted) setState(() => _start--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
              listener: (context, state) {
                if (state is RegisterOtpsuccess) {
                  Navigator.pushNamed(context, Routes.NewPassScreen);
                } else if (state is OtpResendSuccess) {
                  Appsnackbar.showSuccess(context, "otp.resend_success".tr());
                } else if (state is AuthBlocError) {
                  String errorkey = "error.something_wrong".tr();
                  print(" من اسيرفر خطأ :${state.message}");
                  if (state.message.contains("Invalid") ||
                      state.message.contains("wrong")) {
                    errorkey = "otp.invalid_code";
                  } else if (state.message.contains("Network")) {
                    errorkey = "errors.no_internet";
                  }
                  Appsnackbar.showError(context, errorkey.tr());
                }
              },
              builder: (context, state) {
                print("Current State is:$state");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: isDark ? Colors.white : Colors.black,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "otp.title".tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),
                    Text(
                      "${"otp.sent_to".tr()} +963 9**",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 60),

                    OtpFields(controller: otpController),

                    const SizedBox(height: 40),

                    TextButton(
                      onPressed: (_start == 0 && state is! OtpResendLoading)
                          ? () {
                              startTimer();
                              context.read<AuthBlocBloc>().add(
                                ResendOtpEvent("password_reset"),
                              );
                            }
                          : null,
                      child: state is OtpResendLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _start == 0
                                  ? "otp.resend_button".tr()
                                  : "${"otp.resend_text".tr()} ${_start}s",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: _start == 0
                                    ? AppColors.primary
                                    : Colors.grey,
                                decoration: _start == 0
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                            ),
                    ),

                    const SizedBox(height: 80),
                    state is AuthBlocLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            text: "otp.verify_button".tr(),
                            onPressed: () {
                              print("Button pressed");
                              if (otpController.text.length == 6) {
                                context.read<AuthBlocBloc>().add(
                                  RegisterOtpVerified(
                                    otpController.text,
                                    type: "password_reset",
                                  ),
                                );
                              } else {
                                Appsnackbar.showError(
                                  context,
                                  'otp.error_incomplete'.tr(),
                                );
                              }
                            },
                          ),

                    const SizedBox(height: 24),
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
