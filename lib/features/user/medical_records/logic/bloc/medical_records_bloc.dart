import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/features/user/medical_records/data/repos/medical_records_repo.dart';
import 'medical_records_event.dart';
import 'medical_records_state.dart';

class MedicalRecordsBloc
    extends Bloc<MedicalRecordsEvent, MedicalRecordsState> {
  final MedicalRecordsRepo medicalRecordsRepo;

  MedicalRecordsBloc(this.medicalRecordsRepo) : super(MedicalRecordsState()) {
    // 1. جلب الملف الطبي

    on<GetMedicalProfileEvent>((event, emit) async {
      emit(
        state.copyWith(
          profileStatus: MedicalRecordsStatus.loading,

          clearActionStatus: true,
        ),
      );

      try {
        final result = await medicalRecordsRepo.getMedicalProfile();
        emit(
          state.copyWith(
            profileStatus: MedicalRecordsStatus.success,
            patientData: result,
          ),
        );
      } catch (e) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');

        if (_isProfileNotFoundError(errorMsg)) {
          emit(
            state.copyWith(
              // نضع success مع كائن فارغ لإظهار واجهة إنشاء الملف
              profileStatus: MedicalRecordsStatus.success,
              patientData: PatientDataModel.empty(),
              clearErrorMessage: true,
            ),
          );
        } else {
          // خطأ حقيقي في الشبكة أو الخادم
          emit(
            state.copyWith(
              profileStatus: MedicalRecordsStatus.error,
              errorMessage: errorMsg,
            ),
          );
        }
      }
    });

    // 2. تحديث الملف الطبي (نصوص: فصيلة الدم، العنوان، الطوارئ، ...)

    on<UpdateMedicalProfileEvent>((event, emit) async {
      emit(
        state.copyWith(
          actionStatus: ActionStatus.loading,
          clearErrorMessage: true,
          clearSuccessMessage: true,
        ),
      );

      try {
        final message = await medicalRecordsRepo.updateMedicalProfile(
          event.requestModel.toJson(),
        );
        emit(
          state.copyWith(
            actionStatus: ActionStatus.success,
            successMessage: message,
          ),
        );
      } catch (e) {
        final cleanError = e.toString().replaceAll('Exception: ', '');
        emit(
          state.copyWith(
            actionStatus: ActionStatus.error,
            errorMessage: cleanError,
          ),
        );
      }
    });

    // 3. رفع وثيقة

    on<UploadDocumentEvent>((event, emit) async {
      emit(
        state.copyWith(
          actionStatus: ActionStatus.loading,
          clearErrorMessage: true,
          clearSuccessMessage: true,
        ),
      );

      try {
        final message = await medicalRecordsRepo.uploadDocument(
          file: event.file,
          documentType: event.documentType,
          description: event.description,
        );
        emit(
          state.copyWith(
            actionStatus: ActionStatus.success,
            successMessage: message,
          ),
        );
      } catch (e) {
        final cleanError = e.toString().replaceAll('Exception: ', '');
        emit(
          state.copyWith(
            actionStatus: ActionStatus.error,
            errorMessage: cleanError,
          ),
        );
      }
    });

    // 4. حذف وثيقة

    on<DeleteDocumentEvent>((event, emit) async {
      emit(
        state.copyWith(
          actionStatus: ActionStatus.loading,
          clearErrorMessage: true,
          clearSuccessMessage: true,
        ),
      );

      try {
        final message = await medicalRecordsRepo.deleteDocument(
          event.documentId,
        );
        emit(
          state.copyWith(
            actionStatus: ActionStatus.success,
            successMessage: message,
          ),
        );
      } catch (e) {
        final cleanError = e.toString().replaceAll('Exception: ', '');
        emit(
          state.copyWith(
            actionStatus: ActionStatus.error,
            errorMessage: cleanError,
          ),
        );
      }
    });
  }

  bool _isProfileNotFoundError(String error) {
    final lowerError = error.toLowerCase();
    return lowerError.contains('patient profile not found') ||
        lowerError.contains('profile not found') ||
        lowerError.contains('404') ||
        lowerError.contains('not found');
  }
}
