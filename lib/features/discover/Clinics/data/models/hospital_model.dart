class HospitalModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? logo;
  final int specializationsCount;
  final double averageRating;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.logo,
    required this.specializationsCount,
    required this.averageRating,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'],
      specializationsCount: json['specializations_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
    );
  }
}
