import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/features/user/medical_records/data/repos/medical_records_repo.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final MedicalRecordsRepo medicalRecordsRepo;

  ProfileSetupBloc(this.medicalRecordsRepo)
    : super(ProfileSetupState.initial()) {
    on<UpdateDraftDataEvent>((event, emit) {
      emit(state.copyWith(draftData: event.updatedData));
    });

    on<SubmitProfileEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileSetupStatus.loading));

      try {
        final message = await medicalRecordsRepo.updateMedicalProfile(
          state.draftData.toJson(),
        );

        emit(
          state.copyWith(
            status: ProfileSetupStatus.success,
            successMessage: message,
          ),
        );
      } catch (e) {
        final cleanError = e.toString().replaceAll('Exception: ', '');
        emit(
          state.copyWith(
            status: ProfileSetupStatus.error,
            errorMessage: cleanError,
          ),
        );
      }
    });
  }
}
