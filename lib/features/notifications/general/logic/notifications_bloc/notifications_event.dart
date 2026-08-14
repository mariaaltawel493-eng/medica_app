part of 'notifications_bloc.dart';

abstract class NotificationsEvent {}

// 1) حدث جلب الإشعارات لأول مرة (أو عند عمل Pull to Refresh)
class FetchNotificationsEvent extends NotificationsEvent {}

// 2) حدث جلب الصفحة التالية (عندما يصل المستخدم إلى نهاية القائمة)
class FetchMoreNotificationsEvent extends NotificationsEvent {}

// 3) حدث تحديد إشعار معين كمقروء عند الضغط عليه
class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int notificationId;
  MarkNotificationAsReadEvent(this.notificationId);
}

// 4) حدث تحديد كل الإشعارات كمقروءة دفعة واحدة
class MarkAllNotificationsAsReadEvent extends NotificationsEvent {}
