part of 'doctors_bloc.dart';

@immutable
sealed class DoctorsEvent {}

class FetchDoctorsEvent extends DoctorsEvent {
  final int clinicId;
  final int specializationId;
  FetchDoctorsEvent(this.clinicId, this.specializationId);
}

class FetchAllDoctorsEvent extends DoctorsEvent {}

class SearchDoctorsEvent extends DoctorsEvent {
  final int clinicId;
  final int specializationId;
  final String name;
  SearchDoctorsEvent(this.clinicId, this.specializationId, this.name);
}

class SearchAllDoctorsEvent extends DoctorsEvent {
  final String name;
  SearchAllDoctorsEvent(this.name);
}
