

import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/data/models/available_slots_model.dart';

abstract class AppointmentsRepo {
  /// GET /api/appointments  (مع فلتر type اختياري: new / follow_up ...)
  Future<List<AppointmentModel>> getAppointments({String? type});

  /// GET /api/appointments/{id}
  Future<AppointmentModel> getAppointmentDetails(int id);

  /// GET /api/appointments/dates?clinic_id=&doctor_id=&month=&year=
  Future<List<AvailableDateModel>> getAvailableDates({
    required int clinicId,
    required int doctorId,
    required int month,
    required int year,
  });

  /// GET /api/appointments/slots?clinic_id=&doctor_id=&date=
  Future<List<TimeSlotModel>> getAvailableSlots({
    required int clinicId,
    required int doctorId,
    required DateTime date,
  });

  /// POST /api/appointments
  Future<AppointmentModel> createAppointment({
    required int clinicId,
    required int doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required String type,
  });

  /// POST /api/appointments/{id}/cancel
  Future<void> cancelAppointment(int id, {String? reason});

  /// GET /api/appointments/{id}/prescriptions
  Future<List<dynamic>> getPrescriptions(int appointmentId);

  /// POST /api/appointments/{id}/redeem  (استبدال النقاط)
  Future<void> redeemPoints(int appointmentId);
}
