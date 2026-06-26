part of 'profile_setup_bloc.dart';

enum ProfileSetupStatus { initial, loading, success, error }

class ProfileSetupState {
  final PatientDataModel draftData;
  final ProfileSetupStatus status;
  final String? errorMessage;
  final String? successMessage;

  ProfileSetupState({
    required this.draftData,
    this.status = ProfileSetupStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  factory ProfileSetupState.initial() {
    return ProfileSetupState(draftData: PatientDataModel.empty());
  }

  ProfileSetupState copyWith({
    PatientDataModel? draftData,
    ProfileSetupStatus? status,
    String? errorMessage,
    String? successMessage,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return ProfileSetupState(
      draftData: draftData ?? this.draftData,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
