import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/Image_picker_helper.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

class FillProfilScreen extends StatefulWidget {
  const FillProfilScreen({super.key});

  @override
  State<FillProfilScreen> createState() => _FillProfilScreenState();
}

class _FillProfilScreenState extends State<FillProfilScreen> {
  final formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController(); //للتايخ
  String selectGender = "";
  File? profileImage;
  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text("Fill Your Profile".tr())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: isDark
                            ? AppColors.darktextfield
                            : AppColors.textfield,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,

                        child: profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey.shade500,
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: () async {
                            File? image =
                                await ImagePickerHelper.picImageFromGallery();
                            if (image != null) {
                              setState(() {
                                profileImage = image; //تحديث الصورة بالواجهة
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30), // مسافة بين الصورة وأول حقل
                AppTextField(
                  controller: firstnameController,
                  hintText: "First Name".tr(),
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter your first name".tr();
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: lastnameController,
                  hintText: "Last Name".tr(),
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter your last name".tr();
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: emailController,
                  hintText: "Email".tr(),
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email".tr();
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return "Please enter a valid email address".tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: dobController,
                  hintText: "Date of Birth".tr(),
                  prefixIcon: Icons.calendar_month,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),

                      // 2. هون الشغل كله لدعم الثيمين (الخلفية والألوان)
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            // نعدل الألوان بناءً على قيمة isDark
                            colorScheme: isDark
                                ? ColorScheme.dark(
                                    // ألوان الثيم الغامق
                                    primary: AppColors
                                        .primary, // اللون الأزرق للاختيار
                                    onPrimary:
                                        Colors.white, // لون الخط جوا الدائرة
                                    surface: AppColors
                                        .darktextfield, // خلفية المربع (تصير غامقة)
                                    onSurface:
                                        Colors.white, // لون الأرقام والنصوص
                                  )
                                : ColorScheme.dark(
                                    // ملاحظة: حتى بالفاتح يفضل استخدام ColorScheme منظم
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: Colors.white, // خلفية بيضاء للفاتح
                                    onSurface:
                                        Colors.black, // أرقام سوداء للفاتح
                                    brightness:
                                        Brightness.light, // تحديد إنه فاتح
                                  ),
                            // لون خلفية الديالوج نفسه (المربع الكبير)
                            dialogBackgroundColor: isDark
                                ? AppColors.darktextfield
                                : Colors.white,

                            // تعديل ألوان أزرار "OK" و "Cancel"
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    AppColors.primary, // لون أزرار التحكم
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    // 3. وضع التاريخ المختار في الحقل
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      setState(() {
                        dobController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select your date of birth".tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    // خيار ذكر (Male)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectGender = "Male"),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: selectGender == "Male"
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selectGender == "Male"
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Male".tr(),
                              style: TextStyle(
                                color: selectGender == "Male"
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // خيار أنثى (Female)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectGender = "Female"),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: selectGender == "Female"
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selectGender == "Female"
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Female".tr(),
                              style: TextStyle(
                                color: selectGender == "Female"
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                BlocConsumer<AuthBlocBloc, AuthBlocState>(
                  listener: (context, state) {
                    if (state is AuthBlocSuccess) {
                      Navigator.pushNamed(context, '/home');
                    } else if (State is AuthBlocError) {
                      Appsnackbar.showError(
                        context,
                        (state as AuthBlocError).message.tr(),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthBlocLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AppButton(
                      text: "Continue".tr(),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (selectGender.isEmpty) {
                            Appsnackbar.showError(
                              context,
                              'Pleas select your gender'.tr(),
                            );
                            return;
                          }
                          context.read<AuthBlocBloc>().add(
                            RegisterFinalSubmitted(
                              firstnameController.text,
                              lastnameController.text,
                              emailController.text,
                              profileImage,
                              dobController.text,
                              selectGender,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
