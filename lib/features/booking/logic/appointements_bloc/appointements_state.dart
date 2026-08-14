part of 'appointements_bloc.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}
class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;
  AppointmentsLoaded(this.appointments);
}

class AppointmentsEmpty extends AppointmentsState {}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

class AppointmentCancelling extends AppointmentsState {}
class AppointmentCancelSuccess extends AppointmentsState {}

class AppointmentCancelError extends AppointmentsState {
  final String message;
  AppointmentCancelError(this.message);
}