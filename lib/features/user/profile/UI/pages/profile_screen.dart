import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/user/profile/UI/widgets/coustom_profile_menuItem.dart';
import 'package:medica_app/features/user/profile/UI/widgets/profile_header.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
        builder: (context, state) {
          // 1. حالة التحميل
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة النجاح
          if (state is ProfileSuccess) {
            final user = state.userModel.userData;
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // الجزء العلوي: سهم الرجوع والعنوان
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "profile.title".tr(),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darktextPrimary
                                  : AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // الهيدر (الصورة، الاسم، الرقم)
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      name: user.fullName,
                      phone: user.phone,
                      imageUrl: user.profile,
                      onEditImage: () {
                        // سنبرمجها لاحقاً
                      },
                    ),
                  ),

                  // قائمة الخيارات (MenuItems)
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
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.person_outline,
                          title: "profile.edit_profile".tr(),
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.payment_outlined,
                          title: "profile.payment".tr(),
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.shield_outlined,
                          title: "profile.change_password".tr(),
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.language_outlined,
                          title: "profile.language".tr(),
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: "profile.dark_mode".tr(),
                          isSwitch: true,
                          switchValue:
                              Theme.of(context).brightness == Brightness.dark,
                          onSwitchChanged: (val) {
                            // منطق تغيير الثيم سيوضع هنا
                          },
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.people_outline,
                          title: "profile.invite_friends".tr(),
                          onTap: () {},
                        ),
                        CustomProfileMenuItem(
                          icon: Icons.help_outline,
                          title: "profile.help_center".tr(),
                          onTap: () {},
                        ),

                        // زر تسجيل الخروج بلون أحمر
                        CustomProfileMenuItem(
                          icon: Icons.logout,
                          title: "profile.logout".tr(),
                          color: Colors.red,
                          onTap: () {
                            // تنفيذ الـ Logout
                          },
                        ),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. حالة الخطأ
          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBlocBloc>().add(
                        FetchProfileDataEvent(),
                      );
                    },
                    child: Text("profile.retry".tr()),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
