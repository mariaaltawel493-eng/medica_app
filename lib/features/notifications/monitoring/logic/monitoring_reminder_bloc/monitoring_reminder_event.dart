part of 'monitoring_reminder_bloc.dart';

abstract class MonitoringReminderEvent {}

// 1) حدث الجلب الأول للقائمة
class FetchMonitoringRemindersEvent extends MonitoringReminderEvent {}

// 2) حدث جلب المزيد عند السكرول (Pagination)
class FetchMoreMonitoringRemindersEvent extends MonitoringReminderEvent {}

// 3) حدث تسجيل القيمة المقاسة للمؤشر الحيوي (مثل نسبة السكر أو الضغط)
class LogMonitoringValueEvent extends MonitoringReminderEvent {
  final int reminderId;
  final String value;

  LogMonitoringValueEvent({required this.reminderId, required this.value});
}
