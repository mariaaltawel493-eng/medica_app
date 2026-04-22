import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/%D9%90Appalerts.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_Dialod.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class NewPassScreen extends StatefulWidget {
  const NewPassScreen({super.key});

  @override
  State<NewPassScreen> createState() => NewPassScreenstate();
}

class NewPassScreenstate extends State<NewPassScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              // حالة النجاح من البلوك
              AppAlerts.showResultDialog(
                context: context,
                title: "new_password.success_title".tr(),
                subtitle: "new_password.success_message".tr(),
                type: DialogType.success,
                onSuccessFinished: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              );
            } else if (state is AuthBlocError) {
              print("SERVER ERROR LOG ${state.message}");
              Appsnackbar.showError(context, state.message.tr());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            "new_password.title".tr(),
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
                      Center(
                        child: Image.asset(
                          "assets/images/create_new_password.png",
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 30),
                      Text(
                        "new_password.instruction".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      AppTextField(
                        controller: passwordController,
                        hintText: "new_password.".tr(),
                        isPassword: !isPasswordVisible,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "validation.password_required".tr();
                          if (value.length < 8)
                            return "validation.password_short".tr();
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        controller: confirmPasswordController,
                        hintText: "new_password.Confirm_Password".tr(),
                        isPassword: !isConfirmVisible,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () => setState(
                            () => isConfirmVisible = !isConfirmVisible,
                          ),
                        ),
                        validator: (value) {
                          if (value != passwordController.text)
                            return "validation.password_mismatch".tr();
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.primary,
                            onChanged: (v) => setState(() => rememberMe = v!),
                          ),
                          Text(
                            "new_password.remember_me".tr(),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      state is AuthBlocLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : AppButton(
                              text: "new_password.continue_button".tr(),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBlocBloc>().add(
                                    ResetPasswordSubmitted(
                                      "",
                                      passwordController.text,
                                      confirmPasswordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
