import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'monitoring_reminder_event.dart';
part 'monitoring_reminder_state.dart';

class MonitoringReminderBloc extends Bloc<MonitoringReminderEvent, MonitoringReminderState> {
  MonitoringReminderBloc() : super(MonitoringReminderInitial()) {
    on<MonitoringReminderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
