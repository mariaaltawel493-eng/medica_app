part of 'specializations_bloc.dart';

sealed class SpecializationsEvent {}

class FetchSpecializationsEvent extends SpecializationsEvent {
  final int clinicId;
  FetchSpecializationsEvent(this.clinicId);
}
