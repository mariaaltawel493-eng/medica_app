import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http show Response;
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/auth/data/models/login_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/register_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/resetpassword_request_model.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;
  AuthRepoImpl(this.apiService);
  Future<UserModel> login(LoginRequestModel loginRequest) async {
    try {
      final Response = await apiService.post(
        'auth/login',
        loginRequest.toJson(),
      );
      return UserModel.fromJson(Response);
    } catch (e) {
      //إعادة رمي الخطأ ليصل إلى blc
      rethrow;
    }
  }

  /////////////////OTP////////////////
  @override
  Future<void> sendOtp({required String phone, required String type}) async {
    await apiService.post('auth/send-otp', {'phone': phone, 'type': type});
  }

  @override
  Future<void> verifyOtp({
    required String phone,
    required String code,
    required String type,
  }) async {
    await apiService.post('auth/verify-otp', {
      'phone': phone,
      'code': code,
      'type': type,
    });
  }

  ////////////////////////إنشاء حساب//////////////////////
  @override
  Future<UserModel> register(RegisterRequestModel registerRequest) async {
    try {
      // 1. إرسال البيانات والصورة
      final streamedResponse = await apiService.postMultipart(
        endpoint: 'auth/register',
        fields: registerRequest.toMap(),
        imageFile: registerRequest.profileImage,
      );

      // 2. تحويل الرد لقراءة محتواه
      final response = await http.Response.fromStream(streamedResponse);

      // 3. تحليل الـ JSON
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      //فحص الحالة
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(responseData['data']);
      } else {
        // رمي رسالة الخطأ القادمة من السيرفر
        throw responseData['message'] ?? "فشل إنشاء الحساب";
      }
    } catch (e) {
      // إعادة رمي الخطأ للـ Bloc
      rethrow;
    }
  }
  ///////////إعادة تعيين كلمة المرور

  Future<UserModel> resetPassword(
    ResetpasswordRequestModel resetpassReuest,
  ) async {
    try {
      final response = await apiService.post(
        'auth/reset-password',
        resetpassReuest.toJson(),
      );
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
