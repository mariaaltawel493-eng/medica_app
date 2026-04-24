import 'dart:io';

import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';

abstract class ProfileRepo {
  // دالة لجلب بيانات البروفايل
  Future<UserModel> getprofile();

  Future<UserModel> UpdateProfile(ProfileRequestModel profileRequest);
  Future<UserModel> UpdateProfileImage(File imageFile);
  Future<UserModel> UpdatePhone(String newphone);
}
