import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // أضفنا هذا الاستيراد
import 'package:medica_app/core/helpers/%D9%90Appalerts.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/routing/service_locator.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/profile/UI/widgets/update_phone_otp_sheet.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // تأكدي من مسار البلوك عندك

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  String? phoneErrorText;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController(text: "United state");

    // الخطوة 1: نطلب من البلوك جلب البيانات فور فتح الشاشة
    context.read<ProfileBlocBloc>().add(FetchProfileDataEvent());
    _loadSavedCountry();
  }

  Future<void> _loadSavedCountry() async {
    final pref = await SharedPreferences.getInstance();
    String? savedCountry = pref.getString('User_country');
    if (savedCountry != null && mounted) {
      setState(() {
        countryController.text = savedCountry;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
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
          'profile.edit_profile'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      // الخطوة 2: نستخدم BlocConsumer لنسمع للتغيرات ونملأ الحقول
      body: BlocConsumer<ProfileBlocBloc, ProfileBlocState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            // أول ما البيانات تيجي بنجاح، بنعبّي الـ Controllers
            final user = state.userprofilemodel.data;
            print("User Email from API :${user?.email}");
            firstNameController.text = user?.firstName ?? "";
            lastNameController.text = user?.lastName ?? "";
            emailController.text = user?.email ?? "";
            phoneController.text = user?.phone ?? "";
          }
          if (state is sendUpdatePhoneOtpSuccess) {
            Appsnackbar.showSuccess(context, state.message);
            showUpdatePhoneOtpSheet(
              context: context,
              newPhone: phoneController.text.trim(),
              profileBloc: context.read<ProfileBlocBloc>(),
            );
          }
          if (state is UpdatePhoneSuccess) {
            Appsnackbar.showSuccess(context, state.message);

            context.read<ProfileBlocBloc>().add(ResentProfileStateEvent());
            Navigator.of(context).pop();
          }
          if (state is UpdateProfileSuccess) {
            Appsnackbar.showSuccess(context, "تم تحديث البيانات بنجاح");
            context.read<ProfileBlocBloc>().add(FetchProfileDataEvent());
          }

          if (state is ProfileError) {
            print("error from server:${state.message}");
            String errorkey = "errors.something_wrong";
            if (state.message.contains('SocketException') ||
                state.message.contains('connection')) {
              errorkey = "errors.no_internet";
            } else if (state.message.contains('taken') ||
                state.message.contains('already exists')) {
              errorkey = "errors.phone_exists";
            } else if (state.message.contains("invalid") ||
                state.message.contains('code')) {
              errorkey = "otp.invalid_code";
            }
            Appsnackbar.showError(context, errorkey.tr());
            context.read<ProfileBlocBloc>().add(FetchProfileDataEvent());
          }
        },
        builder: (context, state) {
          // الخطوة 3: إذا كان عم يحمل، بنعرض مؤشر تحميل
          if (state is UpdateProfileLoding) {}

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextField(
                      hintText: 'profile.first_name'.tr(),
                      prefixIcon: Icons.person_outline,
                      controller: firstNameController,
                    ),
                    const SizedBox(height: 35),
                    AppTextField(
                      hintText: 'profile.last_name'.tr(),
                      prefixIcon: Icons.person_outline,
                      controller: lastNameController,
                    ),
                    const SizedBox(height: 35),
                    AppTextField(
                      hintText: 'profile.email'.tr(),
                      prefixIcon: Icons.email_outlined,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "validation.email_req".tr();
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return "validation.email_invalid".tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),
                    AppTextField(
                      hintText: "profile.country".tr(),
                      //prefixIcon: Icons.public_outlined,
                      controller: countryController,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                      readOnly: true,

                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            backgroundColor: isDark
                                ? AppColors.darkscaffoldBackground
                                : AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(30),
                            bottomSheetHeight:
                                MediaQuery.of(context).size.height * 0.5,
                          ),
                          onSelect: (Country country) async {
                            String countryData =
                                "${country.flagEmoji}  ${country.name}";
                            setState(() {
                              countryController.text = countryData;
                            });
                            final pref = await SharedPreferences.getInstance();
                            await pref.setString('User_country', countryData);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 35),
                    AppTextField(
                      hintText: 'profile.phone_number'.tr(),
                      prefixIcon: Icons.phone_android_outlined,
                      controller: phoneController,
                      readOnly: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "validation.phone_required".tr();
                        if (value.length != 10)
                          return "validation.phone_invalid".tr();
                        return null;
                      },
                      suffixIcon: Icon(Icons.edit_note_rounded),
                    ),

                    const SizedBox(height: 75),
                    state is UpdateProfileLoding
                        ? const Center(child: AppLoadingIndicator())
                        : AppButton(
                            text: 'profile.Update'.tr(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final bloc = context.read<ProfileBlocBloc>();
                                final state = bloc.state;

                                if (state is ProfileSuccess) {
                                  final oldData = state.userprofilemodel.data;

                                  // تنظيف الأرقام من أي شي مو رقم (مسافات، رموز مخفية)
                                  final String newPhone = phoneController.text
                                      .replaceAll(RegExp(r'\D'), '');
                                  final String oldPhone = (oldData?.phone ?? "")
                                      .toString()
                                      .replaceAll(RegExp(r'\D'), '');

                                  // 1. هل فعلاً تغير الرقم؟
                                  if (newPhone != oldPhone &&
                                      newPhone.isNotEmpty) {
                                    print(
                                      "Detected PHONE change. Showing OTP...",
                                    );
                                    bloc.add(
                                      sendUpdatePhoneOtpEvent(
                                        type: 'phone_update',
                                      ),
                                    );
                                  }
                                  // 2. إذا الرقم نفسه، هل تغيرت البيانات التانية؟
                                  else if (firstNameController.text.trim() !=
                                          (oldData?.firstName ?? "") ||
                                      lastNameController.text.trim() !=
                                          (oldData?.lastName ?? "") ||
                                      emailController.text.trim() !=
                                          (oldData?.email ?? "")) {
                                    print(
                                      "Detected DATA change. Direct Update...",
                                    );
                                    bloc.add(
                                      UpdateProfileEvent(
                                        ProfileRequestModel(
                                          firstName: firstNameController.text
                                              .trim(),
                                          lastName: lastNameController.text
                                              .trim(),
                                          email: emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  }
                                  // 3. ما في شي تغير
                                  else {
                                    Appsnackbar.showError(
                                      context,
                                      "لم تقم بتغيير أي بيانات",
                                    );
                                  }
                                }
                              }
                            },
                          ),
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
