class DoctorModel {
  final int id;
  final String name;
  final String specialization;
  final double rating;
  final String? profile;
  final double consultationFee;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.profile,
    required this.consultationFee,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      rating: (json['rating'] ?? 0).toDouble(),
      profile: json['profile'],
      consultationFee:
          double.tryParse(json['consultation_fee']?.toString() ?? '0') ?? 0,
    );
  }
}
