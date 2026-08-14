part of 'medication_reminder_bloc.dart';

abstract class MedicationReminderEvent {}

// 1) حدث الجلب الأول للقائمة
class FetchMedicationRemindersEvent extends MedicationReminderEvent {}

// 2) حدث جلب المزيد عند السكرول (Pagination)
class FetchMoreMedicationRemindersEvent extends MedicationReminderEvent {}

// 3) حدث إضافة تذكير دواء جديد
class CreateMedicationReminderEvent extends MedicationReminderEvent {
  final Map<String, dynamic> medicationData;
  CreateMedicationReminderEvent(this.medicationData);
}

// 4) حدث تأكيد أخذ جرعة الدواء
class LogMedicationTakenEvent extends MedicationReminderEvent {
  final int reminderId;
  final String timeSlot;
  LogMedicationTakenEvent({required this.reminderId, required this.timeSlot});
}

// 5) حدث تعديل بيانات تذكير الدواء
class UpdateMedicationReminderEvent extends MedicationReminderEvent {
  final int reminderId;
  final Map<String, dynamic> medicationData;

  UpdateMedicationReminderEvent({
    required this.reminderId,
    required this.medicationData,
  });
}

// 6) حدث حذف تذكير الدواء نهائياً
class DeleteMedicationReminderEvent extends MedicationReminderEvent {
  final int reminderId;

  DeleteMedicationReminderEvent(this.reminderId);
}
