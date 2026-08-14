import 'package:medica_app/core/networking/api_service.dart';

import 'medication_reminder_repo.dart';
import '../models/medication_reminder_model.dart';

class MedicationReminderRepoImpl implements MedicationReminderRepo {
  final ApiService apiService;

  MedicationReminderRepoImpl(this.apiService);

  @override
  Future<MedicationReminderResponseModel> getMedicationReminders({
    int? lastId,
    int limit = 15,
  }) async {
    try {
      String endpoint = 'medication-reminders?limit=$limit';
      if (lastId != null) {
        endpoint += '&last_id=$lastId';
      }

      final response = await apiService.get(endpoint);
      return MedicationReminderResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MedicationReminderModel> createMedicationReminder(
    Map<String, dynamic> data,
  ) async {
    try {
      // دالة الـ store في الباكيند ترسل البيانات عبر POST لمسار الأدوية
      final response = await apiService.post('medication-reminders', data);
      return MedicationReminderModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> logMedicationTaken({
    required int reminderId,
    required String timeSlot,
  }) async {
    try {
      // دالة الـ logTaken في الباكيند تنتظر POST على مسار: medication-reminders/{id}/log-taken
      final response = await apiService.post(
        'medication-reminders/$reminderId/log-taken',
        {'time_slot': timeSlot},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MedicationReminderModel> updateMedicationReminder({
    required int reminderId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // دالة الـ update في الباكيند ترسل البيانات عبر POST أو PUT/PATCH حسب تهيئة الـ ApiService
      // الباكيند عندكِ يتعامل مع الـ update بـ Request يحتوي على البيانات ورقم الـ id في الرابط
      final response = await apiService.put(
        'medication-reminders/$reminderId',
        body: data,
      );
      return MedicationReminderModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMedicationReminder(int reminderId) async {
    try {
      // دالة الـ destroy في الباكيند تنتظر طلب حذف على المسار بالـ id الخاص بالدواء
      // إذا كان الـ apiService يحتوي على دالة delete نستخدمها، أو نمررها بالطريقة المعتمدة لديكِ
      await apiService.delete('medication-reminders/$reminderId');
    } catch (e) {
      rethrow;
    }
  }
}
