import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/notifications/medication/data/models/medication_reminder_model.dart';
import 'package:medica_app/features/notifications/medication/data/repos/medication_reminder_repo.dart';

part 'medication_reminder_event.dart';
part 'medication_reminder_state.dart';

class MedicationReminderBloc
    extends Bloc<MedicationReminderEvent, MedicationReminderState> {
  final MedicationReminderRepo medicationReminderRepo;

  // متغيرات داخلية للحفاظ على حالة الـ Pagination والقائمة الحالية
  List<MedicationReminderModel> _allReminders = [];
  int? _nextLastId;
  bool _hasMore = false;
  bool _isFetchingMore = false;

  MedicationReminderBloc(this.medicationReminderRepo)
    : super(MedicationReminderInitialState()) {
    on<FetchMedicationRemindersEvent>(_onFetchMedicationReminders);
    on<FetchMoreMedicationRemindersEvent>(_onFetchMoreMedicationReminders);
    on<CreateMedicationReminderEvent>(_onCreateMedicationReminder);
    on<LogMedicationTakenEvent>(_onLogMedicationTaken);
  }

  // 1) جلب القائمة لأول مرة (الصفحة الأولى)
  Future<void> _onFetchMedicationReminders(
    FetchMedicationRemindersEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    emit(MedicationReminderLoadingState());
    try {
      final response = await medicationReminderRepo.getMedicationReminders(
        lastId: null,
      );

      _allReminders = response.data;
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        MedicationReminderSuccessState(
          reminders: _allReminders,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(
        MedicationReminderErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // 2) جلب المزيد عند السكرول (Pagination)
  Future<void> _onFetchMoreMedicationReminders(
    FetchMoreMedicationRemindersEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    if (!_hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    try {
      final response = await medicationReminderRepo.getMedicationReminders(
        lastId: _nextLastId,
      );

      _allReminders.addAll(response.data);
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        MedicationReminderSuccessState(
          reminders: _allReminders,
          hasMore: _hasMore,
        ),
      );
    } catch (_) {
      // في الـ Load More نحافظ على الحالة السابقة دون إظهار شاشة خطأ كاملة
    } finally {
      _isFetchingMore = false;
    }
  }

  // 3) إضافة تذكير دواء جديد
  Future<void> _onCreateMedicationReminder(
    CreateMedicationReminderEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    emit(MedicationReminderLoadingState());
    try {
      final newReminder = await medicationReminderRepo.createMedicationReminder(
        event.medicationData,
      );

      // إضافة الدواء الجديد محلياً في أول القائمة لتحديث الواجهة فوراً
      _allReminders.insert(0, newReminder);

      emit(CreateMedicationReminderSuccessState(newReminder));

      // إعادة بث النجاح للقائمة لكي تتحدث الشاشة الرئيسية تلقائياً
      emit(
        MedicationReminderSuccessState(
          reminders: _allReminders,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(
        MedicationReminderErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // 4) تسجيل أخذ جرعة الدواء
  Future<void> _onLogMedicationTaken(
    LogMedicationTakenEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    try {
      // نبلغ السيرفر في الخلفية بأخذ الجرعة
      await medicationReminderRepo.logMedicationTaken(
        reminderId: event.reminderId,
        timeSlot: event.timeSlot,
      );

      // بث حالة النجاح الخاصة بالجرعة لتحديث الزر الخاص بها في الواجهة
      emit(
        LogMedicationTakenSuccessState(
          reminderId: event.reminderId,
          timeSlot: event.timeSlot,
        ),
      );
    } catch (e) {
      emit(
        MedicationReminderErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
