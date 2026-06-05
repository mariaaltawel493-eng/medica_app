import 'dart:io';

import 'package:http/http.dart';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/models/userprofileModel.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';

class ProfileRepoImp implements ProfileRepo {
  final ApiService apiService;
  ProfileRepoImp(this.apiService);
  @override
  Future<Userprofilemodel> getprofile() async {
    try {
      final response = await apiService.get("profile");
      return Userprofilemodel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Userprofilemodel> UpdateProfile(
    ProfileRequestModel profileRequest,
  ) async {
    try {
      final response = await apiService.put(
        'profile',
        body: profileRequest.toJson(),
      );
      return Userprofilemodel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> UpdateProfileImage(File imageFile) async {
    try {
      final response = await apiService.postMultipart(
        endpoint: 'profile/image',
        fields: {},
        File: imageFile,
        fileKey: 'profile',
      );
      return response['message'] ?? "success";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendUpdatePhoneOtp({required String type}) async {
    try {
      final response = await apiService.post('profile/send-otp', {
        'type': type,
      });
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyAndUpdatePhone({
    required String new_phone,
    required String code,
  }) async {
    try {
      final response = await apiService.put(
        'profile/phone',
        body: {'new_phone': new_phone, 'code': code},
      );
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> changePassword({
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiService.put(
        'profile/password',
        body: {
          'code': code,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }
}
