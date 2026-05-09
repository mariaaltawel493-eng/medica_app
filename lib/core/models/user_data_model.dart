import 'package:flutter/foundation.dart';

class UserDataModel {
  final int id;
  final String? uuid;
  final String firstName;
  final String lastName;
  final String phone;
  final String? email;
  final String? role;
  final String? profile; // وضعنا ? لأن الحقل قد يأتي null من السيرفر

  UserDataModel({
    required this.id,
    this.uuid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email,
    this.role,
    this.profile,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final String rawName = json['name'] ?? '';
    final String rawFirstName = json['first_name'] ?? '';
    final String rawLastName = json['last_name'] ?? '';

    // 2. منطق ذكي: إذا كان first_name موجود نأخذه، وإذا لا نأخذ الكلمة الأولى من name
    String fName = rawFirstName.isNotEmpty
        ? rawFirstName
        : (rawName.contains(' ') ? rawName.split(' ').first : rawName);

    // 3. نفس المنطق للاسم الأخير
    String lName = rawLastName.isNotEmpty
        ? rawLastName
        : (rawName.contains(' ') ? rawName.split(' ').last : '');
    return UserDataModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'],
      firstName: fName,
      lastName: lName,
      phone: json['phone'] ?? '',
      email: json['email'],
      role: json['role'],
      profile: json['profile'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'role': role,
      'profile': profile,
    };
  }

  factory UserDataModel.empty() {
    return UserDataModel(
      id: 0,
      uuid: '',
      firstName: '',
      lastName: '',
      phone: '',
      email: '',
      role: '',
      profile: null,
    );
  }

  // ميزة إضافية: الحصول على الاسم الكامل مباشرة
  String get fullName => "$firstName $lastName".trim();
}
