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

  // 🎯 متغير محلي لحفظ المواعيد التي تم تسجيلها كـ "مأخوذة" في الجلسة الحالية
  final Set<String> _loggedTakenSlots = {};

  MedicationReminderBloc(this.medicationReminderRepo)
    : super(MedicationReminderInitialState()) {
    on<FetchMedicationRemindersEvent>(_onFetchMedicationReminders);
    on<FetchMoreMedicationRemindersEvent>(_onFetchMoreMedicationReminders);
    on<CreateMedicationReminderEvent>(_onCreateMedicationReminder);
    on<LogMedicationTakenEvent>(_onLogMedicationTaken);

    // 🎯 تسجيل الأحداث الجديدة للتعديل والحذف
    on<UpdateMedicationReminderEvent>(_onUpdateMedicationReminder);
    on<DeleteMedicationReminderEvent>(_onDeleteMedicationReminder);
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
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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

  // 4) تعديل تذكير دواء موجود مسبقاً
  Future<void> _onUpdateMedicationReminder(
    UpdateMedicationReminderEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    emit(MedicationReminderLoadingState());
    try {
      // استدعاء الـ Repo لتعديل البيانات في السيرفر
      final updatedReminder = await medicationReminderRepo
          .updateMedicationReminder(
            reminderId: event.reminderId,
            data: event.medicationData,
          );

      // تحديث العنصر داخل القائمة المحلية فوراً للـ التزامن اللحظي
      final index = _allReminders.indexWhere((r) => r.id == event.reminderId);
      if (index != -1) {
        _allReminders[index] = updatedReminder;
      }

      // بث حالة نجاح التعديل لإغلاق الشاشة أو إشعار المستخدم
      emit(UpdateMedicationReminderSuccessState(updatedReminder));

      // إعادة بث حالة النجاح للقائمة الكلية المحدثة بالبيانات الجديدة
      emit(
        MedicationReminderSuccessState(
          reminders: List.from(_allReminders),
          hasMore: _hasMore,
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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

  // 5) حذف تذكير دواء نهائياً
  Future<void> _onDeleteMedicationReminder(
    DeleteMedicationReminderEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    emit(MedicationReminderLoadingState());
    try {
      // استدعاء الـ Repo لحذف الدواء من السيرفر
      await medicationReminderRepo.deleteMedicationReminder(event.reminderId);

      // إزالة الدواء محلياً فوراً من القائمة الكلية المتوفرة في الذاكرة
      _allReminders.removeWhere((r) => r.id == event.reminderId);

      // بث حالة نجاح الحذف
      emit(DeleteMedicationReminderSuccessState(event.reminderId));

      // إعادة بث حالة النجاح للقائمة الكلية لكي يختفي العنصر من الشاشة الرئيسية
      emit(
        MedicationReminderSuccessState(
          reminders: List.from(_allReminders),
          hasMore: _hasMore,
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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

  // 6) تسجيل أخذ جرعة الدواء
  Future<void> _onLogMedicationTaken(
    LogMedicationTakenEvent event,
    Emitter<MedicationReminderState> emit,
  ) async {
    try {
      await medicationReminderRepo.logMedicationTaken(
        reminderId: event.reminderId,
        timeSlot: event.timeSlot,
      );

      final String slotKey = "${event.reminderId}_${event.timeSlot}";
      _loggedTakenSlots.add(slotKey);

      emit(
        LogMedicationTakenSuccessState(
          reminderId: event.reminderId,
          timeSlot: event.timeSlot,
        ),
      );

      emit(
        MedicationReminderSuccessState(
          reminders: List.from(_allReminders),
          hasMore: _hasMore,
          loggedTakenSlots: Set.from(_loggedTakenSlots),
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
