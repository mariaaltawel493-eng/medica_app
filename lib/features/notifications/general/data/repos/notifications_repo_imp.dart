import 'package:medica_app/features/notifications/general/data/repos/notifications_repo.dart';

import '../models/notification_model.dart';
import '../../../../../core/networking/api_service.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final ApiService apiService;

  NotificationsRepoImpl(this.apiService);

  @override
  Future<NotificationResponseModel> getNotifications({
    int? lastId,
    int limit = 15,
  }) async {
    try {
      String endpoint = 'notifications?limit=$limit';
      if (lastId != null) {
        endpoint += '&last_id=$lastId';
      }

      final response = await apiService.get(endpoint);

      return NotificationResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await apiService.get('notifications/unread-count');

      return response['data']['unread_count'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await apiService.post('notifications/$notificationId/read', {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await apiService.post('notifications/read-all', {});
    } catch (e) {
      rethrow;
    }
  }
}
