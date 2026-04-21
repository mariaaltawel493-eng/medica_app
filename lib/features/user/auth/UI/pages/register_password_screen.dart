import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class RegisterPasswordScreen extends StatefulWidget {
  const RegisterPasswordScreen({super.key});

  @override
  State<RegisterPasswordScreen> createState() => RegisterPasswordScreenState();
}

class RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    "assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png",
                    height: 150,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Secure your Account".tr(),
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
                  "Creat a strong password to prodect your medical records."
                      .tr(),
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darktextSecondary
                        : AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                // حقل كلمة السر الأول
                Text(
                  "Password".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: passwordController,
                  hintText: "Enter password".tr(),
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "يرجى إدخال كلمة المرور".tr();
                    if (value.length < 6)
                      return "password must be at least 6 digits".tr();
                  },
                ),

                const SizedBox(height: 20),
                Text(
                  "Confirm Password".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm your password".tr(),
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) => val != passwordController.text
                      ? "Passwords do not match".tr()
                      : null,
                ),

                const SizedBox(height: 50), // مساحة قبل الزر

                BlocConsumer<AuthBlocBloc, AuthBlocState>(
                  listener: (context, state) {
                    if (state is RegisterPasswordSuccess) {
                      Navigator.pushNamed(context, 'fill_profile');
                      print("password is ${passwordController.text}");
                    } else if (state is AuthBlocError) {
                      Appsnackbar.showError(context, state.message.tr());
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthBlocLoading)
                      return const Center(child: CircularProgressIndicator());

                    return AppButton(
                      text: "Continue".tr(),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBlocBloc>().add(
                            RegisterPassword(passwordController.text),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
