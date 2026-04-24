import 'dart:io';

import 'package:http/http.dart';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';

class ProfileRepoImp implements ProfileRepo {
  final ApiService apiService;
  ProfileRepoImp(this.apiService);
  @override
  Future<UserModel> getprofile() async {
    try {
      final response = await apiService.get("profile");
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> UpdateProfile(ProfileRequestModel profileRequest) async {
    try {
      final response = await apiService.put(
        'profile/update',
        body: profileRequest.toJson(),
      );
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> UpdatePhone(String newphone) async {
    try {
      final response = await apiService.put(
        'profile/update_phone',
        body: {'phone': newphone},
      );
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> UpdateProfileImage(File imageFile) async {
    try {
      final response = await apiService.postMultipart(
        endpoint: 'profile/update_image',
        fields: {},
        imageFile: imageFile,
      );
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
