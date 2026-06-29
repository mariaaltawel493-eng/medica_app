import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/clinics/UI/pages/doctor_details_screen.dart';
import 'package:medica_app/features/discover/clinics/logic/dictors_details_bloc/doctor_details_bloc.dart';
import 'package:medica_app/features/discover/clinics/logic/doctors_bloc/doctors_bloc.dart';
import 'package:medica_app/features/discover/clinics/UI/widgets/doctor_card.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<DoctorsBloc>(
      create: (context) =>
          GetIt.instance.get<DoctorsBloc>()..add(FetchAllDoctorsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                          'doctors.all_doctors'.tr(),
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
                    const SizedBox(height: 20),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkcardBackground
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            context.read<DoctorsBloc>().add(
                              FetchAllDoctorsEvent(),
                            );
                          } else {
                            context.read<DoctorsBloc>().add(
                              SearchAllDoctorsEvent(value),
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
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: BlocConsumer<DoctorsBloc, DoctorsState>(
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
                              physics: const BouncingScrollPhysics(),
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
                                        builder: (_) => BlocProvider(
                                          create: (_) =>
                                              GetIt.I<DoctorDetailsBloc>(),
                                          child: DoctorDetailsScreen(
                                            doctorId: doctor.id,
                                          ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
