import 'dart:io';

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final File? profileImage;
  final String dateOfBirth;
  final String gender;
  final String code;
  final String password_confirmation;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    this.profileImage,
    required this.dateOfBirth,
    required this.gender,
    required this.code,
    required this.password_confirmation,
  });

  // الدالة المصلحة تماماً للتوافق مع الباك إند
  Map<String, String> toMap() {
    String gendervalue = gender.trim().toLowerCase();
    if (gendervalue != "male" && gendervalue != 'female') {
      gendervalue = 'female';
    }
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      'code': code,
      // 1. تصحيح اسم الحقل (كان فيه خطأ إملائي)
      'password_confirmation': password_confirmation,
      // 2. إزالة علامات الاستفهام لأن المتغير أصلاً String وليس String?
      'date_of_birth': dateOfBirth,
      'gender': gender,
    };
  }
}
