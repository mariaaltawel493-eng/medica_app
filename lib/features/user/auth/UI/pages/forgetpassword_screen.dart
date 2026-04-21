import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الثيم الحالي
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // استخدام ألوان الخلفية من ملف الألوان الخاص بكِ
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is RegisterPhoneSuccess) {
            Navigator.pushNamed(context, 'otp_reset');
          }
          if (state is AuthBlocError) {
            Appsnackbar.showError(context, state.message.tr());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
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
                          "Forget Password".tr(),
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

                    const SizedBox(height: 30),

                    // 2. الصورة (Illustrations)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: Image.asset(
                        "assets/images/forgot_password.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Enter your phone number to reset password".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darktextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 30),

                    AppTextField(
                      controller: phoneController,
                      hintText: "Enter your phone".tr(),
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.call_outlined,
                    ),

                    const SizedBox(height: 20),

                    // 5. حاوية خيار الواتساب (تنسيق مطابق للصورة)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(
                                0xff1C2A2D,
                              ) // لون داكن يميل للخضرة ليناسب الواتساب في الدارك
                            : const Color(
                                0xffE8F5E9,
                              ), // لون فاتح (Mint) للـ Light Mode
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "we_will_send_otp_whatsapp".tr(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),
                    state is AuthBlocLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            text: "continue".tr(),
                            onPressed: () {
                              if (phoneController.text.isNotEmpty) {
                                context.read<AuthBlocBloc>().add(
                                  RegisterPhoneSubmitted(
                                    phoneController.text,
                                    "password_reset",
                                  ),
                                );
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
