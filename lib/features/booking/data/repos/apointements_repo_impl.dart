// FILE: lib/features/booking/data/repos/apointements_repo_imp.dart
// ✅ نسخة نظيفة نهائية — بدون أي print statements (كلها كانت مؤقتة
// للتشخيص وتم التأكد من شكل الردود، فما عاد فيه داعي إلها).
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/data/models/available_slots_model.dart';
import 'package:medica_app/features/booking/data/repos/apointements_repo.dart';

class AppointmentsRepoImp implements AppointmentsRepo {
  final ApiService apiService;

  AppointmentsRepoImp(this.apiService);

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<List<AppointmentModel>> getAppointments({String? type}) async {
    final endpoint = (type == null || type.isEmpty)
        ? 'appointments'
        : 'appointments?type=$type';
    final response = await apiService.get(endpoint);

    final list = response is Map
        ? (response['data'] ?? response['appointments'] ?? [])
        : response;

    if (list is! List) return [];
    return list
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AppointmentModel> getAppointmentDetails(int id) async {
    final response = await apiService.get('appointments/$id');
    final data = response is Map && response['data'] != null
        ? response['data']
        : response;
    return AppointmentModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<AvailableDateModel>> getAvailableDates({
    required int clinicId,
    required int doctorId,
    required int month,
    required int year,
  }) async {
    final endpoint =
        'appointments/dates?clinic_id=$clinicId&doctor_id=$doctorId&month=$month&year=$year';
    final response = await apiService.get(endpoint);
    return AvailableDateModel.listFromResponse(response);
  }

  @override
  Future<List<TimeSlotModel>> getAvailableSlots({
    required int clinicId,
    required int doctorId,
    required DateTime date,
  }) async {
    final endpoint =
        'appointments/slots?clinic_id=$clinicId&doctor_id=$doctorId&date=${_fmtDate(date)}';
    final response = await apiService.get(endpoint);
    return TimeSlotModel.listFromResponse(response);
  }

  @override
  Future<AppointmentModel> createAppointment({
    required int clinicId,
    required int doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required String type,
  }) async {
    final body = {
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'appointment_date': _fmtDate(appointmentDate),
      'appointment_time': appointmentTime,
      'type': type,
    };
    final response = await apiService.post('appointments', body);
    final data = response is Map && response['data'] != null
        ? response['data']
        : response;
    return AppointmentModel.fromJson(
      (data is Map<String, dynamic>) ? data : body,
    );
  }

  @override
  Future<void> cancelAppointment(int id, {String? reason}) async {
    await apiService.post(
      'appointments/$id/cancel',
      reason == null || reason.isEmpty ? {} : {'reason': reason},
    );
  }

  @override
  Future<List<dynamic>> getPrescriptions(int appointmentId) async {
    final response = await apiService.get(
      'appointments/$appointmentId/prescriptions',
    );
    final list = response is Map
        ? (response['data'] ?? response['prescriptions'] ?? [])
        : response;
    return list is List ? list : [];
  }



  @override
  Future<void> redeemPoints(int appointmentId) async {
    await apiService.post('appointments/$appointmentId/redeem', {});
  }
}
