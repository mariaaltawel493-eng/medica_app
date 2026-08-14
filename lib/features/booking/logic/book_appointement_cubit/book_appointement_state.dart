part of 'book_appointement_cubit.dart';   // ⚠️ لازم "appointement" بالضبط (بدون t قبل الآخر) متل اسم ملف الكيوبت

enum BookAppointmentStatus { idle, loadingDates, loadingSlots, submitting, success, failure }
enum AppointmentPackage { messaging, voiceCall }

class BookAppointmentState {
  final BookAppointmentStatus status;

  // بيانات أساسية للحجز
  final int clinicId;
  final int doctorId;

  // خطوة 1: التاريخ والساعة
  final List<AvailableDateModel> availableDates;
  final List<TimeSlotModel> availableSlots;
  final DateTime? selectedDate;
  final String? selectedTime;

  // خطوة 2: الباقة
  final AppointmentPackage? selectedPackage;

  // خطوة 3: بيانات المريض لهاي الاستشارة (Write Your Problem...)
  final String fullName;
  final String? gender;
  final String? age;
  final String problemDescription;

  // خطوة 4: الدفع
  final String? selectedPaymentMethod; // paypal / google_pay / apple_pay

  final AppointmentModel? createdAppointment;
  final String? errorMessage;

  const BookAppointmentState({
    this.status = BookAppointmentStatus.idle,
    required this.clinicId,
    required this.doctorId,
    this.availableDates = const [],
    this.availableSlots = const [],
    this.selectedDate,
    this.selectedTime,
    this.selectedPackage,
    this.fullName = '',
    this.gender,
    this.age,
    this.problemDescription = '',
    this.selectedPaymentMethod,
    this.createdAppointment,
    this.errorMessage,
  });

  bool get canGoToPackageStep => selectedDate != null && selectedTime != null;
  bool get canGoToDetailsStep => selectedPackage != null;
  bool get canGoToPaymentStep =>
      fullName.trim().isNotEmpty && problemDescription.trim().isNotEmpty;
  bool get canSubmit => selectedPaymentMethod != null;

  BookAppointmentState copyWith({
    BookAppointmentStatus? status,
    List<AvailableDateModel>? availableDates,
    List<TimeSlotModel>? availableSlots,
    DateTime? selectedDate,
    String? selectedTime,
    AppointmentPackage? selectedPackage,
    String? fullName,
    String? gender,
    String? age,
    String? problemDescription,
    String? selectedPaymentMethod,
    AppointmentModel? createdAppointment,
    String? errorMessage,
  }) {
    return BookAppointmentState(
      status: status ?? this.status,
      clinicId: clinicId,
      doctorId: doctorId,
      availableDates: availableDates ?? this.availableDates,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      problemDescription: problemDescription ?? this.problemDescription,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      errorMessage: errorMessage,
    );
  }
}
