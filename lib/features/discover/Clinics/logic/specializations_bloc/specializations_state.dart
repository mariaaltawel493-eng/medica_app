part of 'specializations_bloc.dart';

sealed class SpecializationsState {}

class SpecializationsInitial extends SpecializationsState {}

class SpecializationsLoading extends SpecializationsState {}

class SpecializationsSuccess extends SpecializationsState {
  final List<SpecializationModel> specializations;
  SpecializationsSuccess(this.specializations);
}

class SpecializationsError extends SpecializationsState {
  final String message;
  SpecializationsError(this.message);
}
