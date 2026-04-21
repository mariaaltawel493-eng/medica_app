import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as sharedPrefHelper;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/data/models/login_request_model.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkcardBackground
          : AppColors.scaffoldBackground,
      body: BlocListener<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) async {
          if (state is AuthBlocSuccess) {
            await SharedPrefHelper.saveUserToken(state.user.token);
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is AuthBlocError) {
            print("error from server:${state.message}");
            String errorMessage = "حدث خطأ ما، يرجى المحاولة لاحقاً"
                .tr(); // رسالة افتراضية
            if (state.message.contains("Invalid credentials")) {
              errorMessage = "رقم الهاتف أو كلمة المرور غير صحيحة".tr();
            } else if (state.message.contains("Network is unreachable")) {
              errorMessage = "لا يوجد اتصال بالإنترنت، تأكد من الشبكة".tr();
            } else if (state.message.contains("required")) {
              errorMessage = "يرجى ملء جميع الحقول المطلوبة".tr();
            } else if (state.message.contains("not found")) {
              errorMessage = "هذا الحساب غير موجود".tr();
            }

            // استدعاء السناك بار اللي جهزناه
            Appsnackbar.showError(context, errorMessage.tr());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png',
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome back!".tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    hintText: "Enter your Phone number".tr(),
                    prefixIcon: Icons.call_outlined,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يرجى إدخال رقم الهاتف".tr();
                      if (value.length < 10)
                        return "رقم الهاتف يجب ان يكون 10 أرقام".tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    hintText: "Enter your password".tr(),
                    prefixIcon: Icons.lock_outlined,
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يرجى إدخال كلمة المرور".tr();
                      if (value.length < 8)
                        return "كلمة المرور قصيرة جداً".tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'reset_password');
                      },
                      child: Text(
                        "Forgot your password?".tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 2. استخدام BlocBuilder هنا فقط لتغيير شكل الزر عند التحميل
                  BlocBuilder<AuthBlocBloc, AuthBlocState>(
                    builder: (context, state) {
                      if (state is AuthBlocLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return AppButton(
                        text: "Log in".tr(),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            context.read<AuthBlocBloc>().add(
                              LoginSubmittedEvent(
                                LoginRequestModel(
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You don’t have an account?".tr(),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "make a new one".tr(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
