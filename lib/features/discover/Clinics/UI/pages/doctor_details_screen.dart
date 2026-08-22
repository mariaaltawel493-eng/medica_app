import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/booking/ui/pages/book_appointement_flow_screen.dart';
import 'package:medica_app/features/booking/ui/pages/my_appointements_screen.dart';
import 'package:medica_app/features/discover/Clinics/logic/dictors_details_bloc/doctor_details_bloc.dart';
import 'package:medica_app/features/discover/clinics/UI/pages/hospitals_screen.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorId;
  final int? clinicId;

  const DoctorDetailsScreen({super.key, required this.doctorId, this.clinicId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _onBookPressed(BuildContext context, String doctorName) async {
    int clinicId;

    if (widget.clinicId != null) {
      clinicId = widget.clinicId!;
    } else {
      final selectedClinicId = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HospitalsScreen(doctorId: widget.doctorId, selectionMode: true),
        ),
      );

      if (selectedClinicId == null) return;

      clinicId = selectedClinicId;
    }

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookAppointmentFlowScreen(
          args: BookAppointmentArgs(
            clinicId: clinicId,
            doctorId: widget.doctorId,
            doctorName: doctorName,
          ),
        ),
      ),
    );
  }

  // ✅ ويدجت مساعدة لعرض الصورة البديلة (أيقونة رمادية)
  Widget _buildImagePlaceholder() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey.shade200,
      child: Icon(Icons.person, size: 60, color: Colors.grey.shade500),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => DoctorDetailsBloc(getIt<ClinicsRepo>())
        ..add(FetchDoctorDetailsEvent(widget.doctorId, widget.clinicId ?? 0)),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkscaffoldBackground
              : AppColors.scaffoldBackground,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
        body: BlocConsumer<DoctorDetailsBloc, DoctorDetailsState>(
          listener: (context, state) {
            if (state is DoctorDetailsError) {
              String errorKey;
              // ✅ تم إصلاح الخطأ البرمجي هنا بإضافة ||
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
            if (state is DoctorDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DoctorDetailsError) {
              return const SizedBox();
            }
            if (state is DoctorDetailsSuccess) {
              final doctor = state.doctor;

              // ✅ التحقق من أن الرابط موجود وليس فارغاً
              final bool hasValidImage =
                  doctor.profile != null && doctor.profile!.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: hasValidImage
                              ? Image.network(
                                  doctor.profile!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  // ✅ في حال كان الرابط مكسور يعرض البديل
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildImagePlaceholder(),
                                )
                              // ✅ في حال لم يكن هناك رابط من الأساس يعرض البديل
                              : _buildImagePlaceholder(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darktextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                doctor.specialization,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    doctor.rating.toString(),
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darktextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      doctor.clinicName,
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.darktextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'doctor_details.consultation_fee'.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${doctor.consultationFee.toInt()} SYP',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'doctor_details.availability'.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        doctor.availabilityText,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'doctor_details.about'.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          doctor.bio,
                          style: TextStyle(
                            height: 1.8,
                            color: isDark
                                ? AppColors.darktextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _onBookPressed(context, doctor.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'doctor_details.book'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
