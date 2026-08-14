part of 'doctor_details_bloc.dart';

sealed class DoctorDetailsState {}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsSuccess extends DoctorDetailsState {
  final DoctorDetailsModel doctor;
  DoctorDetailsSuccess(this.doctor);
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;
  DoctorDetailsError(this.message);
}
