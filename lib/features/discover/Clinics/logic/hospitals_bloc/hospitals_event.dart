part of 'hospitals_bloc.dart';

sealed class HospitalsEvent {}

class FetchHospitalsEvent extends HospitalsEvent {}

class SearchHospitalsEvent extends HospitalsEvent {
  final String query;
  SearchHospitalsEvent(this.query);
}
<<<<<<< HEAD
=======
class FetchDoctorClinicsEvent extends HospitalsEvent {
  final int doctorId;
  FetchDoctorClinicsEvent(this.doctorId);
}
>>>>>>> Sedra
