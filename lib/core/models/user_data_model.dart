class UserDataModel {
  final int id;
  final String uuid;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String role;
  final String? profile; // وضعنا ? لأن الحقل قد يأتي null من السيرفر

  UserDataModel({
    required this.id,
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.role,
    this.profile,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      uuid: json['uuid'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      profile: json['profile'],
    );
  }

  // ميزة إضافية: الحصول على الاسم الكامل مباشرة
  String get fullName => "$firstName $lastName";
}
