// lib/features/user/profile/data/repos/profile_repo_mock.dart

import 'dart:io';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/core/models/user_data_model.dart'; // تأكدي من المسارات
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';

class ProfileRepoMock implements ProfileRepo {
  @override
  Future<UserModel> getprofile() async {
    // محاكاة تأخير الشبكة لمدة ثانيتين
    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      success: true,
      message: "تم جلب البيانات بنجاح",
      token: "mock_token_xyz",
      userData: UserDataModel(
        id: 1,
        firstName: "أحمد",
        lastName: "المنصور",
        email: "ahmed@example.com",
        uuid: '',
        phone: '0938631565',
        role: '',
        profile: "assets/images/password_successful.png",
      ),
      patientData: PatientDataModel(
        id: 10,
        gender: "male",
        dateOfBirth: DateTime(1998, 01, 01),
        qrCodeUrl: '',
      ),
    );
  }

  @override
  Future<UserModel> UpdateProfile(ProfileRequestModel profileRequest) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      success: true,
      message: "تم تحديث البيانات بنجاح (Mock)",
      token: "mock_token_xyz",
      userData: UserDataModel(
        id: 1,
        firstName: profileRequest.firstName,
        lastName: profileRequest.lastName,
        email: profileRequest.email,
        uuid: '',
        phone: '',
        role: '',
      ),
      patientData: PatientDataModel(
        id: 10,
        gender: "male",
        dateOfBirth: DateTime(2003, 16, 10),
        qrCodeUrl: '',
      ),
    );
  }

  @override
  Future<UserModel> UpdatePhone(String newphone) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      success: true,
      message: "تم تحديث الهاتف",
      token: "...",
      userData: UserDataModel(
        id: 1,
        firstName: "أحمد",
        lastName: "المنصور",
        email: "a@a.com",
        uuid: '',
        phone: '',
        role: '',
      ),
      patientData: PatientDataModel(
        id: 1,
        gender: "m",
        dateOfBirth: DateTime(199, 10, 4),
        qrCodeUrl: '',
      ),
    );
  }

  @override
  Future<UserModel> UpdateProfileImage(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      success: true,
      message: "تمت تغيير الصورة بنجاح",
      token: "...",
      userData: UserDataModel(
        id: 1,
        firstName: "أحمد",
        lastName: "المنصور",
        email: "a@a.com",
        uuid: '',
        phone: '',
        role: '',
      ),
      patientData: PatientDataModel(
        id: 1,
        gender: "m",
        dateOfBirth: DateTime(2002, 2, 2),
        qrCodeUrl: '',
      ),
    );
  }
}
