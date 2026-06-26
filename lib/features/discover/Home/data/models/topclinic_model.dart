import 'package:medica_app/core/helpers/constants.dart';

class TopClinicModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? logo;
  final int specializationsCount;
  final num averageRating;

  TopClinicModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.logo,
    required this.specializationsCount,
    required this.averageRating,
  });

  factory TopClinicModel.fromJson(Map<String, dynamic> json) {
    return TopClinicModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'],

      specializationsCount: json['specializations_count'] ?? 0,
      averageRating: json['average_rating'] ?? 0,
    );
  }
}
