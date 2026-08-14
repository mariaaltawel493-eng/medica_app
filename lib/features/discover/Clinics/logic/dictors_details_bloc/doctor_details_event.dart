part of 'doctor_details_bloc.dart';

sealed class DoctorDetailsEvent {}

class FetchDoctorDetailsEvent extends DoctorDetailsEvent {
  final int doctorId;
  final int clinicId;
  FetchDoctorDetailsEvent(this.doctorId, this.clinicId);
}
