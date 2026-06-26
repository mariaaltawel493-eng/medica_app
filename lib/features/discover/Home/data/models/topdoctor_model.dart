class TopDoctorModel {
  final int id;
  final String name;
  final String specialization;
  final num rating;
  final String? profile;

  TopDoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    this.profile,
  });

  factory TopDoctorModel.fromJson(Map<String, dynamic> json) {
    return TopDoctorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      rating: json['rating'] ?? 0,
      profile: json['profile'],
    );
  }
}
