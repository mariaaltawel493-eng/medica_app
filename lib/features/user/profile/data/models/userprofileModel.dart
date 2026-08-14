import 'package:medica_app/core/models/user_data_model.dart';

class Userprofilemodel {
  final String message;
  final UserDataModel data;
  Userprofilemodel({required this.message, required this.data});
  factory Userprofilemodel.fromJson(Map<String, dynamic> json) {
    return Userprofilemodel(
      message: json['message'] ?? '',
      data: UserDataModel.fromJson(json['data'] ?? {}),
    );
  }
}
