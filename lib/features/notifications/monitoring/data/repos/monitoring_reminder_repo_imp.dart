import 'monitoring_reminder_repo.dart';
import '../models/monitoring_reminder_model.dart';
import '../../../../../core/networking/api_service.dart';

class MonitoringReminderRepoImpl implements MonitoringReminderRepo {
  final ApiService apiService;

  MonitoringReminderRepoImpl(this.apiService);

  @override
  Future<MonitoringReminderResponseModel> getMonitoringReminders({
    int? lastId,
    int limit = 15,
  }) async {
    try {
      String endpoint = 'monitoring-reminders?limit=$limit';
      if (lastId != null) {
        endpoint += '&last_id=$lastId';
      }

      final response = await apiService.get(endpoint);
      return MonitoringReminderResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> logMonitoringValue({
    required int reminderId,
    required String value,
  }) async {
    try {
      // دالة الـ logValue في الباكيند تنتظر POST على مسار: monitoring-reminders/{id}/log-value
      final response = await apiService.post(
        'monitoring-reminders/$reminderId/log-value',
        {'value': value},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
