import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/data/repos/apointements_repo.dart';

part 'appointements_event.dart';
part 'appointements_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepo appointmentsRepo;

  AppointmentsBloc(this.appointmentsRepo) : super(AppointmentsInitial()) {
    on<FetchAppointmentsEvent>(_onFetch);
    on<CancelAppointmentEvent>(_onCancel);
  }
  Future<void> _onFetch(
    FetchAppointmentsEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());
    try {
      final all = await appointmentsRepo.getAppointments();

      final filtered = all
          .where((a) => a.effectiveStatus == event.status)
          .toList();

      if (filtered.isEmpty) {
        emit(AppointmentsEmpty());
      } else {
        emit(AppointmentsLoaded(filtered));
      }
    } catch (e) {
      emit(AppointmentsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onCancel(
    CancelAppointmentEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentCancelling());
    try {
      await appointmentsRepo.cancelAppointment(
        event.appointmentId,
        reason: event.reason,
      );
      emit(AppointmentCancelSuccess());
    } catch (e) {
      emit(
        AppointmentCancelError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }
}
