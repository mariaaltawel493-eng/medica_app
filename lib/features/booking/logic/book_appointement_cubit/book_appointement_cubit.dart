import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/data/models/available_slots_model.dart';
import 'package:medica_app/features/booking/data/repos/apointements_repo.dart';

part 'book_appointement_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final AppointmentsRepo appointmentsRepo;

  BookAppointmentCubit(
    this.appointmentsRepo, {
    required int clinicId,
    required int doctorId,
  }) : super(BookAppointmentState(clinicId: clinicId, doctorId: doctorId));

  // ... (باقي الميثودز متل ما هي عندك، ما تغيرت)

  // ── شاشة "Select Date" ───────────────────────────────────────────
  Future<void> fetchAvailableDates({
    required int month,
    required int year,
  }) async {
    emit(state.copyWith(status: BookAppointmentStatus.loadingDates));
    try {
      final dates = await appointmentsRepo.getAvailableDates(
        clinicId: state.clinicId,
        doctorId: state.doctorId,
        month: month,
        year: year,
      );
      emit(
        state.copyWith(
          status: BookAppointmentStatus.idle,
          availableDates: dates,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookAppointmentStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> selectDate(DateTime date) async {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedTime: null,
        status: BookAppointmentStatus.loadingSlots,
      ),
    );
    try {
      final slots = await appointmentsRepo.getAvailableSlots(
        clinicId: state.clinicId,
        doctorId: state.doctorId,
        date: date,
      );
      print('=== SUCCESS: Received ${slots.length} slots ===');
      emit(
        state.copyWith(
          status: BookAppointmentStatus.idle,
          availableSlots: slots,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookAppointmentStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }

  // ── شاشة "Select Package" ───────────────────────────────────────
  void selectPackage(AppointmentPackage package) {
    emit(state.copyWith(selectedPackage: package));
  }

  // ── شاشة "Patient Details" ──────────────────────────────────────
  void updatePatientDetails({
    String? fullName,
    String? gender,
    String? age,
    String? problemDescription,
  }) {
    emit(
      state.copyWith(
        fullName: fullName,
        gender: gender,
        age: age,
        problemDescription: problemDescription,
      ),
    );
  }

  // ── شاشة "Payments" ─────────────────────────────────────────────
  void selectPaymentMethod(String method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  // ── تأكيد الحجز النهائي بعد إدخال الـ PIN ───────────────────────
  // ✅ نرسل فقط الحقول المؤكدة فعلياً بالـ Postman collection:
  //    clinic_id, doctor_id, appointment_date, appointment_time, type
  // (الباقة/بيانات المريض/طريقة الدفع لسا ما إلهن حقل مؤكد بالـ API،
  //  فبينخزنو محلياً لحد ما يتوفر endpoint مخصص للدفع من الباك اند)
  Future<void> submitBooking({String type = 'new'}) async {
    if (state.selectedDate == null || state.selectedTime == null) return;

    emit(state.copyWith(status: BookAppointmentStatus.submitting));
    try {
      final appointment = await appointmentsRepo.createAppointment(
        clinicId: state.clinicId,
        doctorId: state.doctorId,
        appointmentDate: state.selectedDate!,
        appointmentTime: state.selectedTime!,
        type: type,
      );
      emit(
        state.copyWith(
          status: BookAppointmentStatus.success,
          createdAppointment: appointment,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookAppointmentStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
