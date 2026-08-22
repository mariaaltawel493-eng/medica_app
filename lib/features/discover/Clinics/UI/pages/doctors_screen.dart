import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // أضفنا حزمة GetIt
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/clinics/UI/pages/doctor_details_screen.dart';
import 'package:medica_app/features/discover/clinics/UI/widgets/doctor_card.dart';
import 'package:medica_app/features/discover/clinics/logic/doctors_bloc/doctors_bloc.dart';

class DoctorsScreen extends StatefulWidget {
  final int clinicId; // جعلناه يستقبل الـ id الديناميكي بشكل صحيح
  final int specializationId;
  final String specializationName;

  const DoctorsScreen({
    super.key,
    required this.clinicId, // إجباري لنعرف أي عيادة اخترنا
    required this.specializationId,
    required this.specializationName,
  });

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // أفرغنا الـ initState لأن الـ BlocProvider بالأسفل سيتولى جلب البيانات فور الإنشاء
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // توفير الـ Bloc للشاشة وحقن حدث الجلب فوراً لنفس النسخة
    return BlocProvider<DoctorsBloc>(
      create: (context) => GetIt.I<DoctorsBloc>()
        ..add(FetchDoctorsEvent(widget.clinicId, widget.specializationId)),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
          title: Text(
            widget.specializationName,
            style: TextStyle(
              color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocConsumer<DoctorsBloc, DoctorsState>(
          listener: (context, state) {
            if (state is DoctorsError) {
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
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // استخدام Builder لحقل البحث لكي يرى الـ context المحقون بالـ BlocProvider أعلاه
                  Builder(
                    builder: (textFieldContext) {
                      return TextField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            textFieldContext.read<DoctorsBloc>().add(
                                  FetchDoctorsEvent(
                                    widget.clinicId,
                                    widget.specializationId,
                                  ),
                                );
                          } else {
                            textFieldContext.read<DoctorsBloc>().add(
                                  SearchDoctorsEvent(
                                    widget.clinicId,
                                    widget.specializationId,
                                    value,
                                  ),
                                );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'doctors.search'.tr(),
                          hintStyle: TextStyle(
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
                          filled: true,
                          fillColor: isDark
                              ? AppColors.darkcardBackground
                              : AppColors.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is DoctorsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is DoctorsError) {
                          return const SizedBox();
                        }
                        if (state is DoctorsSuccess) {
                          if (state.doctors.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_off_outlined,
                                    size: 70,
                                    color: isDark
                                        ? AppColors.darktextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'doctors.empty'.tr(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darktextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: state.doctors.length,
                            itemBuilder: (context, index) {
                              final doctor = state.doctors[index];
                              return DoctorCard(
                                name: doctor.name,
                                specialization: doctor.specialization,
                                rating: doctor.rating,
                                consultationFee: doctor.consultationFee,
                                profile: doctor.profile,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorDetailsScreen(
                                        doctorId: doctor.id,
                                        clinicId: widget.clinicId,
                                      ),
                                    ),
                                  );
                                },
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
            );
          },
        ),
      ),
    );
  }
}
