class LoginRequestModel {
  final String phone;
  final String password;
  LoginRequestModel({required this.password, required this.phone});
  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }
}
