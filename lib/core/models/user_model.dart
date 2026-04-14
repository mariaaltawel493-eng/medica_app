class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType; // مريض أو طبيب

  UserModel({this.id, this.name, this.email, this.phone, this.userType});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'],
    );
  }
}
