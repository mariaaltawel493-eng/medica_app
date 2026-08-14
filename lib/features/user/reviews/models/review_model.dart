class ReviewModel {
  final int id;
  final int appointmentId;
  final int doctorId;
  final int patientId;
  final int rating;

  ReviewModel({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["id"] ?? 0,
      appointmentId: json["appointment_id"] ?? 0,
      doctorId: json["doctor_id"] ?? 0,
      patientId: json["patient_id"] ?? 0,
      rating: json["rating"] ?? 0,
    );
  }
}