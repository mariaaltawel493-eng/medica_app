import 'dart:io';

class ProfileRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final File? profileImage; // إضافة الصورة هنا لتكون جزءاً من طلب التعديل

  ProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImage,
    this.phoneNumber, // يمكن أن تكون Null إذا أراد المستخدم تعديل البيانات بدون الصورة
  });

  // هذه الدالة لتحويل البيانات النصية فقط لـ Map (لاستخدامها في الـ fields تبع الـ Multipart)
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      if (phoneNumber != null) 'phone': phoneNumber!,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth!,
      if (gender != null) 'gender': gender!,
    };
  }
}
