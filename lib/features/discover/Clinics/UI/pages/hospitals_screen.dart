import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/Clinics/UI/pages/specializations_screen.dart';
<<<<<<< HEAD
import 'package:medica_app/features/discover/clinics/UI/widgets/hospital_card.dart';
import 'package:medica_app/features/discover/clinics/logic/hospitals_bloc/hospitals_bloc.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});
=======
import 'package:medica_app/features/discover/clinics/logic/hospitals_bloc/hospitals_bloc.dart';
import 'package:medica_app/features/discover/clinics/UI/widgets/hospital_card.dart';

class HospitalsScreen extends StatefulWidget {
  // ✅ جديد: لو انبعت doctorId، الشاشة بتجيب بس عيادات هاد الدكتور
  // (مش كل العيادات) — تُستخدم كـ "اختاري عيادة الدكتور" قبل الحجز
  final int? doctorId;

  final bool selectionMode;

  const HospitalsScreen({super.key, this.doctorId, this.selectionMode = false});
>>>>>>> Sedra

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
<<<<<<< HEAD
  void initState() {
    super.initState();
    // تركنا الـ initState فارغة لأن الـ BlocProvider في الأسفل أصبح هو المسؤول عن طلب البيانات فور إنشائه
  }

  @override
=======
>>>>>>> Sedra
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<HospitalsBloc>(
<<<<<<< HEAD
      // الخيار الأفضل: نقوم بإنشاء نسخة الـ Bloc ونطلب جلب البيانات عليها فوراً قبل بناء الشاشة
      create: (context) => GetIt.I<HospitalsBloc>()..add(FetchHospitalsEvent()),
=======
      create: (context) {
        final bloc = GetIt.I<HospitalsBloc>();
        // ✅ حسب الوضع: عيادات دكتور معيّن أو كل العيادات
        if (widget.doctorId != null) {
          bloc.add(FetchDoctorClinicsEvent(widget.doctorId!));
        } else {
          bloc.add(FetchHospitalsEvent());
        }
        return bloc;
      },
>>>>>>> Sedra
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: isDark
                            ? AppColors.darktextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
<<<<<<< HEAD
                      'hospitals.title'.tr(),
=======
                      // ✅ عنوان مختلف بوضع الاختيار
                      widget.selectionMode
                          ? 'اختاري العيادة'
                          : 'hospitals.title'.tr(),
>>>>>>> Sedra
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darktextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
<<<<<<< HEAD
                // حقل البحث
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkcardBackground
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Builder(
                    // نستخدم Builder هنا للحصول على الـ context الصحيح الذي يرى الـ BlocProvider أعلاه
                    builder: (textFieldContext) {
                      return TextField(
                        controller: searchController,
                        onChanged: (value) {
                          // نقرأ من الـ context الحالي لكي نصل لنفس نسخة الـ Bloc النشطة في الشاشة
                          if (value.isEmpty) {
                            textFieldContext.read<HospitalsBloc>().add(
                              FetchHospitalsEvent(),
                            );
                          } else {
                            textFieldContext.read<HospitalsBloc>().add(
                              SearchHospitalsEvent(value),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'hospitals.search'.tr(),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.darktextSecondary
                                : AppColors.textSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark
                                ? AppColors.darktextSecondary
                                : AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'hospitals.all_hospitals'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
=======
                // حقل البحث — نخفيه بوضع الاختيار (عدد عيادات الدكتور
                // غالباً قليل وما محتاج بحث)
                if (!widget.selectionMode) ...[
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkcardBackground
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Builder(
                      builder: (textFieldContext) {
                        return TextField(
                          controller: searchController,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              textFieldContext.read<HospitalsBloc>().add(
                                FetchHospitalsEvent(),
                              );
                            } else {
                              textFieldContext.read<HospitalsBloc>().add(
                                SearchHospitalsEvent(value),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'hospitals.search'.tr(),
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.darktextSecondary
                                  : AppColors.textSecondary,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDark
                                  ? AppColors.darktextSecondary
                                  : AppColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'hospitals.all_hospitals'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darktextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
>>>>>>> Sedra
                Expanded(
                  child: BlocConsumer<HospitalsBloc, HospitalsState>(
                    listener: (context, state) {
                      if (state is HospitalsError) {
                        String errorKey;
                        if (state.message.contains('no_internet') ||
                            state.message.contains('Network') ||
                            state.message.contains('connection')) {
                          errorKey = 'errors.no_internet';
                        } else {
                          errorKey = 'errors.unknown';
                        }
                        Appsnackbar.showError(context, errorKey.tr());
                      }
                    },
                    builder: (context, state) {
                      if (state is HospitalsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is HospitalsError) {
                        return const SizedBox();
                      }
                      if (state is HospitalsSuccess) {
                        if (state.hospitals.isEmpty) {
                          return Center(
<<<<<<< HEAD
                            child: Text('hospitals.no_hospitals'.tr()),
=======
                            child: Text(
                              widget.selectionMode
                                  ? 'ما في عيادات مرتبطة بهاد الدكتور حالياً'
                                  : 'hospitals.no_hospitals'.tr(),
                            ),
>>>>>>> Sedra
                          );
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.hospitals.length,
                          itemBuilder: (context, index) {
                            final hospital = state.hospitals[index];
                            return GestureDetector(
                              onTap: () {
<<<<<<< HEAD
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SpecializationsScreen(
                                      hospitalId: hospital.id,
                                    ),
                                  ),
                                );
=======
                                if (widget.selectionMode) {
                                  // ✅ وضع الاختيار: رجّعي الـ id بس
                                  Navigator.pop(context, hospital.id);
                                } else {
                                  // الوضع العادي: زي ما كان تماماً
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SpecializationsScreen(
                                        hospitalId: hospital.id,
                                      ),
                                    ),
                                  );
                                }
>>>>>>> Sedra
                              },
                              child: HospitalCard(
                                name: hospital.name,
                                address: hospital.address,
                                logo: hospital.logo,
                                specializationsCount:
                                    hospital.specializationsCount,
                                rating: hospital.averageRating,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
