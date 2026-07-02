part of 'medication_reminder_bloc.dart';

abstract class MedicationReminderState {}

class MedicationReminderInitialState extends MedicationReminderState {}

class MedicationReminderLoadingState extends MedicationReminderState {}

// حالة النجاح العامة لجلب البيانات وعرض القائمة
class MedicationReminderSuccessState extends MedicationReminderState {
  final List<MedicationReminderModel> reminders;
  final bool hasMore;

  MedicationReminderSuccessState({
    required this.reminders,
    required this.hasMore,
  });
}

// حالة النجاح عند إضافة دواء جديد لكي نغلق الشاشة أو نُظهر رسالة نجاح
class CreateMedicationReminderSuccessState extends MedicationReminderState {
  final MedicationReminderModel newReminder;
  CreateMedicationReminderSuccessState(this.newReminder);
}

// حالة النجاح عند تسجيل أخذ الجرعة
class LogMedicationTakenSuccessState extends MedicationReminderState {
  final int reminderId;
  final String timeSlot;
  LogMedicationTakenSuccessState({
    required this.reminderId,
    required this.timeSlot,
  });
}

// حالة حدوث خطأ
class MedicationReminderErrorState extends MedicationReminderState {
  final String errorMessage;
  MedicationReminderErrorState(this.errorMessage);
}
