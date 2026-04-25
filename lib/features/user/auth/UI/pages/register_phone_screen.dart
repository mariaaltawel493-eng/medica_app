import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/constants.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class RegisterPhoneScreen extends StatefulWidget {
  @override
  State<RegisterPhoneScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final TextEditingController phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    phonecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is RegisterPhoneSuccess) {
            Navigator.pushNamed(context, '/otp_view');
          } else if (state is AuthBlocError) {
            print("ERROR_SERVER:${state.message}");
            String errorkey = "errors.something_wrong";
            if (state.message.contains("already") ||
                state.message.contains("exists")) {
              errorkey = "errors.phone_exists";
            } else if (state.message.contains("Network") ||
                state.message.contains("connection")) {
              errorkey = "errors.no_internet";
            }
            Appsnackbar.showError(context, errorkey.tr());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        "assets/images/cded31803db071b98fad1c729a1dcde0ce4b4ff6.png",
                        height: 150,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "auth.welcome_title".tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "auth.welcome_subtitle".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      AppTextField(
                        hintText: "auth.phone_hint".tr(),
                        prefixIcon: Icons.call_outlined,
                        controller: phonecontroller,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "validation.phone_required".tr();
                          if (value.length < 10)
                            return "validation.phone_invalid".tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      BlocBuilder<AuthBlocBloc, AuthBlocState>(
                        builder: (context, state) {
                          if (state is AuthBlocLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return AppButton(
                            text: "auth.continue_button".tr(),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                context.read<AuthBlocBloc>().add(
                                  RegisterPhoneSubmitted(
                                    phonecontroller.text,
                                    "register",
                                  ),
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
        },
      ),
    );
  }
}
