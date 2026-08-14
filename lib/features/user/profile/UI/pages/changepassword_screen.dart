import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/profile/UI/widgets/Fieldlabel.dart';
import 'package:medica_app/features/user/profile/UI/widgets/Generic_otp_sheet.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCurrentPassVisible = false;
  bool isNewPassVisible = false;
  bool isConfirmVisible = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "change_password.title".tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: BlocConsumer<ProfileBlocBloc, ProfileBlocState>(
              listener: (context, state) {
                if (state is sendUpdatePhoneOtpSuccess) {
                  Appsnackbar.showSuccess(context, state.message.tr());
                  try {
                    Navigator.of(context, rootNavigator: true).pop();
                  } catch (_) {}
                  showGenericOtpSheet(
                    context: context,
                    isPassword: true,
                    newPassword: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                    profileBloc: context.read<ProfileBlocBloc>(),
                  );
                } else if (state is ChangePasswordSuccess) {
                  try {
                    Navigator.of(context, rootNavigator: true).pop();
                  } catch (_) {}
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) Navigator.pop(context);
                    });
                  }
                  Appsnackbar.showSuccess(context, state.message);
                } else if (state is ProfileError) {
                  Appsnackbar.showError(context, state.message.tr());
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // الهيدر العلوي: سهم الرجوع + العنوان (مثل صفحة البروفايل)
                      const SizedBox(height: 32),

                      // حقل كلمة السر الحالية
                      FieldLabel(text: 'change_password.current_password'.tr()),
                      AppTextField(
                        controller: currentPasswordController,
                        hintText: "change_password.current_password_hint".tr(),
                        isPassword: !isCurrentPassVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isCurrentPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () => setState(
                            () => isCurrentPassVisible = !isCurrentPassVisible,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "validation.password_required".tr();
                          }
                          return null;
                        },
                        // ملاحظة: في الصورة التصميم لا يوجد Icons داخل الحقل، إذا أردت حذفها احذفي السطر التالي
                        prefixIcon: Icons.lock_outline,
                      ),

                      const SizedBox(height: 24),

                      // حقل كلمة السر الجديدة
                      FieldLabel(text: "change_password.new_password".tr()),
                      AppTextField(
                        controller: newPasswordController,
                        hintText: "change_password.new_password_hint".tr(),
                        isPassword: !isNewPassVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isNewPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () => setState(
                            () => isNewPassVisible = !isNewPassVisible,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "validation.password_required".tr();
                          }
                          if (value.length < 8) {
                            return "validation.password_short".tr();
                          }
                          return null;
                        },
                        prefixIcon: Icons.lock_outline,
                      ),

                      const SizedBox(height: 24),

                      // حقل تأكيد كلمة السر
                      FieldLabel(text: "change_password.confirm_password".tr()),
                      AppTextField(
                        controller: confirmPasswordController,
                        hintText: "change_password.confirm_password_hint".tr(),
                        isPassword: !isConfirmVisible,
                        prefixIcon: Icons.lock_outline,
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
                          if (value == null || value.isEmpty) {
                            return "validation.password_required".tr();
                          }
                          if (value != newPasswordController.text) {
                            return "validation.password_mismatch".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 150,
                      ), // يدفع الزر للأسفل تماماً مثل التصميم
                      // زر التغيير
                      BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                        builder: (context, state) {
                          if (state is UpdateProfileLoding) {
                            return const Center(child: AppLoadingIndicator());
                          }
                          return AppButton(
                            text: "change_password.button".tr(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<ProfileBlocBloc>().add(
                                  sendUpdatePhoneOtpEvent(
                                    type: 'password_change',
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
