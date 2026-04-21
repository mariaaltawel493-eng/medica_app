class ResetpasswordRequestModel {
  final String phone;
  final String code;
  final String password;
  final passwordConfirmation;
  ResetpasswordRequestModel(
    this.phone,
    this.code,
    this.password,
    this.passwordConfirmation,
  );
  Map<String, dynamic> toJson() => {
    "phone": phone,
    "code": code,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
