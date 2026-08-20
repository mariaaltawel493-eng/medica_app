part of 'appointements_bloc.dart';   // ⚠️ لازم "appointements" بالضبط متل اسم البلوك، مش "appointments"

abstract class AppointmentsEvent {}

class FetchAppointmentsEvent extends AppointmentsEvent {
  final AppointmentStatus status;
  FetchAppointmentsEvent(this.status);
}

class CancelAppointmentEvent extends AppointmentsEvent {
  final int appointmentId;
  final String? reason;
  CancelAppointmentEvent(this.appointmentId, {this.reason});
}