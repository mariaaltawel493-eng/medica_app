import '../models/medication_reminder_model.dart';

abstract class MedicationReminderRepo {
  // 1) جلب قائمة التذكيرات مع الـ Pagination
  Future<MedicationReminderResponseModel> getMedicationReminders({
    int? lastId,
    int limit = 15,
  });

  // 2) إضافة تذكير دواء جديد
  Future<MedicationReminderModel> createMedicationReminder(
    Map<String, dynamic> data,
  );

  // 3) تأكيد أخذ جرعة الدواء
  Future<Map<String, dynamic>> logMedicationTaken({
    required int reminderId,
    required String timeSlot,
  });
}
