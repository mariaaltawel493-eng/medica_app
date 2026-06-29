part of 'doctors_bloc.dart';

@immutable
sealed class DoctorsState {}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsSuccess extends DoctorsState {
  final List<DoctorModel> doctors;
  DoctorsSuccess(this.doctors);
}

class DoctorsError extends DoctorsState {
  final String message;
  DoctorsError(this.message);
}
