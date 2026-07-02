import '../models/monitoring_reminder_model.dart';

abstract class MonitoringReminderRepo {
  // 1) جلب قائمة تذكيرات المؤشرات مع الـ Pagination
  Future<MonitoringReminderResponseModel> getMonitoringReminders({
    int? lastId,
    int limit = 15,
  });

  // 2) تسجيل القيمة المقاسة (مثال: تسجيل قياس الضغط أو السكر)
  Future<Map<String, dynamic>> logMonitoringValue({
    required int reminderId,
    required String value,
  });
}
