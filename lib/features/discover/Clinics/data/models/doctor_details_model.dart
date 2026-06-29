class DoctorDetailsModel {
  final int id;
  final String name;
  final String specialization;
  final String bio;
  final double rating;
  final String? profile;
  final String clinicName;
  final double consultationFee;
  final List<dynamic> availability;

  DoctorDetailsModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.rating,
    required this.profile,
    required this.clinicName,
    required this.consultationFee,
    required this.availability,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'] ?? '',
      bio: json['bio'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      profile: json['profile'],
      clinicName: json['clinic']?['name'] ?? '',
      consultationFee:
          double.tryParse(json['consultation_fee']?.toString() ?? '0') ?? 0,
      availability: json['availability'] ?? [],
    );
  }

  String get availabilityText {
    if (availability.isEmpty) return 'No availability';
    final first = availability.first;
    final start = first['start_time'].toString().substring(0, 5);
    final end = first['end_time'].toString().substring(0, 5);
    return 'From $start to $end';
  }
}
