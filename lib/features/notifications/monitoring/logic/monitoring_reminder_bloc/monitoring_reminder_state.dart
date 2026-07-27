part of 'monitoring_reminder_bloc.dart';

abstract class MonitoringReminderState {}

class MonitoringReminderInitialState extends MonitoringReminderState {}

class MonitoringReminderLoadingState extends MonitoringReminderState {}

// حالة النجاح في جلب قائمة المؤشرات الحيوية
class MonitoringReminderSuccessState extends MonitoringReminderState {
  final List<MonitoringReminderModel> reminders;
  final bool hasMore;

  MonitoringReminderSuccessState({
    required this.reminders,
    required this.hasMore,
  });
}

// حالة النجاح عند تسجيل قيمة القياس بنجاح
class LogMonitoringValueSuccessState extends MonitoringReminderState {
  final int reminderId;
  final String value;

  LogMonitoringValueSuccessState({
    required this.reminderId,
    required this.value,
  });
}

// حالة حدوث خطأ
class MonitoringReminderErrorState extends MonitoringReminderState {
  final String errorMessage;
  MonitoringReminderErrorState(this.errorMessage);
}
