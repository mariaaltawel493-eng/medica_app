part of 'monitoring_reminder_bloc.dart';

sealed class MonitoringReminderState extends Equatable {
  const MonitoringReminderState();
  
  @override
  List<Object> get props => [];
}

final class MonitoringReminderInitial extends MonitoringReminderState {}
