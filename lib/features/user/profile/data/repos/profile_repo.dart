import 'dart:io';

import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/models/userprofileModel.dart';

abstract class ProfileRepo {
  // دالة لجلب بيانات البروفايل
  Future<Userprofilemodel> getprofile();

  Future<Userprofilemodel> UpdateProfile(ProfileRequestModel profileRequest);
  Future<String> UpdateProfileImage(File imageFile);

  Future<String> sendUpdatePhoneOtp({required String type});
  Future<String> verifyAndUpdatePhone({
    required String new_phone,
    required String code,
  });
  Future<String> changePassword({
    required String code,
    required String newPassword,
    required String confirmPassword,
  });
}
