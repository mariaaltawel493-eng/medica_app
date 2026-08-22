import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/Image_picker_helper.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/user/profile/UI/widgets/coustom_profile_menuItem.dart';
import 'package:medica_app/features/user/profile/UI/widgets/lang_bottom_sheet.dart';
import 'package:medica_app/features/user/profile/UI/widgets/profile_header.dart';
import 'package:medica_app/features/user/profile/data/models/userprofileModel.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
// --- تم التعديل هنا: استيراد الـ AuthBlocBloc و AuthBlocState لتمكين الاستماع لحالات الـ Logout ---
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';
// ------------------------------------------------------------------------------------------------
import 'package:medica_app/features/user/settings/theme/theme_cubit/theme_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // دالة اختيار ورفع الصورة
  Future<void> _pickAnduploadeImage(BuildContext context) async {
    final File? image = await ImagePickerHelper.picImageFromGallery();
    if (image != null) {
      context.read<ProfileBlocBloc>().add(UpdateProfileImageEvent(image));
    }
  }

  Userprofilemodel? lastValiData;

  @override
  void initState() {
    super.initState();
    // طلب البيانات فوراً من البلوك الموجود في الـ Router
    context.read<ProfileBlocBloc>().add(FetchProfileDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- تم التعديل هنا: دمج MultiBlocListener أو استخدام BlocListener متداخل للتعامل مع حالات الـ Profile والـ Auth معاً ---
    return MultiBlocListener(
      listeners: [
        // 1. استماع حالات البروفايل (مثل تحديث الصورة)
        BlocListener<ProfileBlocBloc, ProfileBlocState>(
          listener: (context, state) {
            if (state is UpdateImageSuccess) {
              Appsnackbar.showSuccess(context, 'profile.image_updated'.tr());
            } else if (state is UpdateImageError) {
              String errorkey = "errors.something_wrong";
              if (state.error.contains("Network") ||
                  state.error.contains("Connection")) {
                errorkey = "errors.no_internet";
              } else if (state.error.contains('Unauthraized')) {
                errorkey = "errors.session_expired";
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.LoginScreen,
                  (route) => false,
                );
              } else {
                errorkey = state.error;
              }
              Appsnackbar.showError(context, errorkey.tr());
            }
          },
        ),
        // 2. استماع حالات المصادقة (تحديداً نجاح أو خطأ تسجيل الخروج Logout)
        BlocListener<AuthBlocBloc, AuthBlocState>(
          listener: (context, authState) {
            if (authState is LogoutSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.LoginScreen,
                (route) => false,
              );
            } else if (authState is AuthBlocError) {
              Appsnackbar.showError(context, authState.message.tr());
            }
          },
        ),
      ],
      // -----------------------------------------------------------------------------------------------------------------
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // الهيدر والبيانات العلوية
              SliverToBoxAdapter(
                child: BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      lastValiData = state.userprofilemodel;
                    }

                    final userData = lastValiData?.data;
                    final bool isLoading = state is ProfileLoading;
                    final bool isImageUploading = state is UpdateImageLoding;
                    final bool isError = state is ProfileError;

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                "profile.title".tr(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ProfileHeader(
                          name:
                              userData?.fullName ??
                              (isLoading ? "Loading..." : "User Name"),
                          phone:
                              userData?.phone ??
                              (isLoading ? "..." : "0000000000"),
                          imageUrl: userData?.profile,
                          onEditImage: () {
                            _pickAnduploadeImage(context);
                          },
                        ),
                        if (isImageUploading)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: AppLoadingIndicator(size: 0.5),
                          ),
                        if (isError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextButton.icon(
                              onPressed: () => context
                                  .read<ProfileBlocBloc>()
                                  .add(FetchProfileDataEvent()),
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                "Retry",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              // القائمة السفلية كاملة
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    const Divider(thickness: 0.5),
                    const SizedBox(height: 16),
                    CustomProfileMenuItem(
                      icon: Icons.assignment_outlined,
                      title: "profile.medical_records".tr(),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.MedicalRecordsScreen,
                        );
                      },
                    ),
                    CustomProfileMenuItem(
                      icon: Icons.person_outline,
                      title: "profile.edit_profile".tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.EditProfileScreen);
                      },
                    ),
                    CustomProfileMenuItem(
                      icon: Icons.payment_outlined,
                      title: "profile.payment".tr(),
                      onTap: () {},
                    ),
                    CustomProfileMenuItem(
                      icon: Icons.shield_outlined,
                      title: "profile.change_password".tr(),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.ChangePasswordScreen,
                        );
                      },
                    ),
                    CustomProfileMenuItem(
                      icon: Icons.language_outlined,
                      title: "profile.language".tr(),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const LanguageBottomSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                    ),
                    CustomProfileMenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: "profile.dark_mode".tr(),
                      isSwitch: true,
                      switchValue: isDark,
                      onSwitchChanged: (val) {
                        context.read<ThemeCubit>().toggleTheme(val);
                      },
                      onTap: () {},
                    ),

                    BlocBuilder<AuthBlocBloc, AuthBlocState>(
                      builder: (context, authState) {
                        final bool isLoggingOut = authState is AuthBlocLoading;
                        return CustomProfileMenuItem(
                          icon: Icons.logout,
                          title: "profile.logout".tr(),
                          color: Colors.red,
                          onTap: isLoggingOut
                              ? () {}
                              : () {
                                  context.read<AuthBlocBloc>().add(
                                    LogoutRequestedEvent(),
                                  );
                                },
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
