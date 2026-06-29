part of 'hospitals_bloc.dart';

sealed class HospitalsState {}

class HospitalsInitial extends HospitalsState {}

class HospitalsLoading extends HospitalsState {}

class HospitalsSuccess extends HospitalsState {
  final List<HospitalModel> hospitals;
  HospitalsSuccess(this.hospitals);
}

class HospitalsError extends HospitalsState {
  final String message;
  HospitalsError(this.message);
}
