part of 'notifications_bloc.dart';

abstract class NotificationsState {}

// 1) الحالة البدائية (قبل بدء أي طلب)
class NotificationsInitialState extends NotificationsState {}

// 2) حالة التحميل البدائي (عند فتح الشاشة لأول مرة وتظهر دائرة التحميل المركزية)
class NotificationsLoadingState extends NotificationsState {}

// 3) حالة النجاح (عند جلب البيانات ويحتوي على قائمة الإشعارات وهل يوجد المزيد أم لا)
class NotificationsSuccessState extends NotificationsState {
  final List<NotificationModel> notifications;
  final bool hasMore;
  final int unreadCount;

  NotificationsSuccessState({
    required this.notifications,
    required this.hasMore,
    required this.unreadCount,
  });
}

// 4) حالة الخطأ (في حال فشل الاتصال بالسيرفر، ويحتوي على نص الخطأ)
class NotificationsErrorState extends NotificationsState {
  final String message;
  NotificationsErrorState(this.message);
}
