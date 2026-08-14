class Changepassrequestmodel {
  final String code;
  final String newPassword;
  final String confirmPassword;
  Changepassrequestmodel(this.code, this.newPassword, this.confirmPassword);

  Map<String, dynamic> toJson() => {
    'code': code,
    'new_password': newPassword,
    'new_password_confirmation': confirmPassword,
  };
}
