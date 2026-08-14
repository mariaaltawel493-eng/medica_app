import 'package:medica_app/features/notifications/general/data/models/notification_model.dart';

abstract class NotificationsRepo {
  // 1) دالة جلب قائمة الإشعارات مع دعم الـ Pagination (التمرير لأسفل)
  Future<NotificationResponseModel> getNotifications({
    int? lastId,
    int limit = 15,
  });

  // 2) دالة جلب عداد الإشعارات غير المقروءة للـ Badge
  Future<int> getUnreadCount();

  // 3) دالة تحديد إشعار معين كمقروء عند الضغط عليه
  Future<void> markAsRead(int notificationId);

  // 4) دالة تحديد كل الإشعارات كمقروءة دفعة واحدة
  Future<void> markAllAsRead();
}
