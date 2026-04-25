import 'package:medica_app/core/models/patient_data_model.dart';

import 'user_data_model.dart';

class UserModel {
  final bool success;
  final String message;
  final String token;
  final UserDataModel userData;
  final PatientDataModel patientData;

  UserModel({
    required this.success,
    required this.message,
    required this.token,
    required this.userData,
    required this.patientData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      message: json['message'],
      // استخراج التوكن من داخل حقل data
      token: json['data']['token'] ?? "",
      // نمرر جزء "user" للموديل الخاص به
      userData: UserDataModel.fromJson(json['data']['user']),
      // نمرر جزء "patient" للموديل الخاص به
      patientData: PatientDataModel.fromJson(json['data']['patient']),
    );
  }
}
