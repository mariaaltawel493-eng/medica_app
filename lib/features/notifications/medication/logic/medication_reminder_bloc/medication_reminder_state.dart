part of 'medication_reminder_bloc.dart';

abstract class MedicationReminderState {}

class MedicationReminderInitialState extends MedicationReminderState {}

class MedicationReminderLoadingState extends MedicationReminderState {}

// حالة النجاح العامة لجلب البيانات وعرض القائمة
class MedicationReminderSuccessState extends MedicationReminderState {
  final List<MedicationReminderModel> reminders;
  final bool hasMore;
  // 🎯 أضفنا هذا المتغير لحفظ الجرعات التي تم أخذها اليوم بصرياً في الذاكرة
  final Set<String> loggedTakenSlots;

  MedicationReminderSuccessState({
    required this.reminders,
    required this.hasMore,
    this.loggedTakenSlots =
        const {}, // قيمة افتراضية فارغة لكي لا يحدث كراش في الأماكن الأخرى
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

// 5) حالة النجاح عند تعديل بيانات الدواء
class UpdateMedicationReminderSuccessState extends MedicationReminderState {
  final MedicationReminderModel updatedReminder;
  UpdateMedicationReminderSuccessState(this.updatedReminder);
}

// 6) حالة النجاح عند حذف الدواء
class DeleteMedicationReminderSuccessState extends MedicationReminderState {
  final int reminderId;
  DeleteMedicationReminderSuccessState(this.reminderId);
}
