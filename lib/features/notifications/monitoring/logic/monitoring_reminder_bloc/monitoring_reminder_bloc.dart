import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/notifications/monitoring/data/models/monitoring_reminder_model.dart';
import 'package:medica_app/features/notifications/monitoring/data/repos/monitoring_reminder_repo.dart';

part 'monitoring_reminder_event.dart';
part 'monitoring_reminder_state.dart';

class MonitoringReminderBloc
    extends Bloc<MonitoringReminderEvent, MonitoringReminderState> {
  final MonitoringReminderRepo monitoringReminderRepo;

  // متغيرات داخلية للحفاظ على حالة الـ Pagination والقائمة الحالية للمؤشرات
  List<MonitoringReminderModel> _allReminders = [];
  int? _nextLastId;
  bool _hasMore = false;
  bool _isFetchingMore = false;

  MonitoringReminderBloc(this.monitoringReminderRepo)
    : super(MonitoringReminderInitialState()) {
    on<FetchMonitoringRemindersEvent>(_onFetchMonitoringReminders);
    on<FetchMoreMonitoringRemindersEvent>(_onFetchMoreMonitoringReminders);
    on<LogMonitoringValueEvent>(_onLogMonitoringValue);
  }

  // 1) جلب القائمة لأول مرة
  Future<void> _onFetchMonitoringReminders(
    FetchMonitoringRemindersEvent event,
    Emitter<MonitoringReminderState> emit,
  ) async {
    emit(MonitoringReminderLoadingState());
    try {
      final response = await monitoringReminderRepo.getMonitoringReminders(
        lastId: null,
      );

      _allReminders = response.data;
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        MonitoringReminderSuccessState(
          reminders: _allReminders,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(
        MonitoringReminderErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // 2) جلب المزيد عند السكرول (Pagination)
  Future<void> _onFetchMoreMonitoringReminders(
    FetchMoreMonitoringRemindersEvent event,
    Emitter<MonitoringReminderState> emit,
  ) async {
    if (!_hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    try {
      final response = await monitoringReminderRepo.getMonitoringReminders(
        lastId: _nextLastId,
      );

      _allReminders.addAll(response.data);
      _hasMore = response.pagination.hasMore;
      _nextLastId = response.pagination.nextLastId;

      emit(
        MonitoringReminderSuccessState(
          reminders: _allReminders,
          hasMore: _hasMore,
        ),
      );
    } catch (_) {
      // الحفاظ على البيانات السابقة في حال حدوث خطأ أثناء السكرول
    } finally {
      _isFetchingMore = false;
    }
  }

  // 3) تسجيل قيمة القياس للمؤشر
  Future<void> _onLogMonitoringValue(
    LogMonitoringValueEvent event,
    Emitter<MonitoringReminderState> emit,
  ) async {
    try {
      // إرسال القياس للسيرفر في الخلفية
      await monitoringReminderRepo.logMonitoringValue(
        reminderId: event.reminderId,
        value: event.value,
      );

      emit(
        LogMonitoringValueSuccessState(
          reminderId: event.reminderId,
          value: event.value,
        ),
      );
    } catch (e) {
      emit(
        MonitoringReminderErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
