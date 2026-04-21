import 'dart:io';

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final File? profileImage;
  final String? dateOfBirth;
  final String? gender;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
  });

  // هذه الدالة لتحويل البيانات النصية فقط إلى Map (لإرسالها مع الصورة لاحقاً)
  Map<String, String> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth!,
      if (gender != null) 'gender': gender!,
    };
  }
}
