import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/user/medical_records/UI/widgets/health_status_card.dart';
import 'package:medica_app/features/user/medical_records/UI/widgets/medical_documents_card.dart';
import 'package:medica_app/features/user/medical_records/UI/widgets/vital_info_card.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_event.dart'; // 💡 قمنا بتعديل الـ import ليدعم جميع الـ Events
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_state.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  @override
  void initState() {
    super.initState();
    // جلب بيانات الملف الطبي فور فتح الشاشة
    context.read<MedicalRecordsBloc>().add(GetMedicalProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'medical.medical_records'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
        listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
        listener: (context, state) {
          if (state.actionStatus == ActionStatus.error &&
              state.errorMessage != null) {
            print('erroe from server:${state.errorMessage}');
            String errorKey = 'errors.something_wrong';
            if (state.errorMessage!.contains('SoketExption') ||
                state.errorMessage!.contains('connection')) {
              errorKey = 'errors.no_internet';
            } else if (state.errorMessage!.contains('not found')) {
              errorKey = 'errors.user_not_found';
            }
            Appsnackbar.showError(context, errorKey.tr());
          }

          if (state.actionStatus == ActionStatus.success) {
            if (state.successMessage != null) {
              Appsnackbar.showSuccess(context, 'success.deleted'.tr());
            }
            // إعادة جلب البيانات لتحديث الشاشة بعد أي عملية ناجحة
            context.read<MedicalRecordsBloc>().add(GetMedicalProfileEvent());
          }
        },
        child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          builder: (context, state) {
            // ── حالة التحميل الأولي فقط ──
            if (state.profileStatus == MedicalRecordsStatus.loading &&
                state.patientData == null) {
              return const Center(child: AppLoadingIndicator());
            }
            // البيانات تؤخذ من السيرفر، أو تكون عبارة عن الكائن الآمن الفارغ الممرر من الـ Bloc
            final patient = state.patientData;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MedicalRecordsBloc>().add(
                  GetMedicalProfileEvent(),
                );
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // ── كرت المعلومات الحيوية ──
                    VitalInfoCard(
                      bloodType: patient?.bloodType ?? '--',
                      address: patient?.address ?? 'medical.no_address'.tr(),
                      emergencyContact: patient?.emergencyContactName != null
                          ? '${patient!.emergencyContactName}'
                                '${patient.emergencyContactRelation != null ? ' (${'medical.${patient.emergencyContactRelation}'.tr()})' : ''}'
                          : 'medical.no_contact'.tr(),
                      phone: patient?.emergencyContactPhone ?? '--',
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          Routes.EditPhysicalProfileScreen,
                          arguments:
                              patient, // يمرر كبيانات أولية للتعديل أو يكون فارغاً بأمان
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── كرت الحالة الصحية ──
                    HealthStatusCard(
                      chronicDiseases: patient?.chronicDiseases,
                      allergies: patient?.allergies,
                      currentMedications: patient?.currentMedications,
                      onEdit: () {
                        Navigator.pushNamed(
                          context,
                          Routes.EditHealthStatusScreen,
                          arguments: patient,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── كرت الوثائق الطبية المحدث والثابت ──
                    MedicalDocumentsCard(
                      // 💡 قمنا بتمرير الملفات من الموديل الذي قمنا بتحديثه
                      documents: patient?.documents ?? const [],

                      // 💡 نمرر المعرف الخاص بالملف الجاري حذفه من الـ State لكي لا تظهر أخطاء
                      deletingDocId: state.actionStatus == ActionStatus.loading
                          ? state.deletingDocumentId
                          : null,

                      // 💡 نطلق حدث الحذف فور ضغط المريض على سلة المهملات في الكارد
                      onDeleteDocument: (docId) {
                        context.read<MedicalRecordsBloc>().add(
                          DeleteDocumentEvent(docId),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
