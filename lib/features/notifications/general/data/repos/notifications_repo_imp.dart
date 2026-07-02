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
      // بناء الـ URL مع الـ Query Parameters الخاصة بالـ Pagination كما يتوقعها Laravel
      String endpoint = 'notifications?limit=$limit';
      if (lastId != null) {
        endpoint += '&last_id=$lastId';
      }

      final response = await apiService.get(endpoint);

      // تحويل الـ JSON القادم من الـ ApiService مباشرة إلى الـ Model الذي شرحناه
      return NotificationResponseModel.fromJson(response);
    } catch (e) {
      rethrow; // إعادة رمي الخطأ ليتم معالجته وعرضه في الـ BLoC والواجهات
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await apiService.get('notifications/unread-count');
      // استخراج الـ unread_count من داخل الـ data Map كما يرسلها الكنترولر تماماً
      return response['data']['unread_count'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      // إرسال طلب POST للمسار المخصص لتحديد الإشعار كمقروء
      await apiService.post('notifications/$notificationId/mark-read', {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      // إرسال طلب POST للمسار المخصص لتحديد الكل كمقروء
      await apiService.post('notifications/mark-all-read', {});
    } catch (e) {
      rethrow;
    }
  }
}
