import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart';
import 'package:http/http.dart' as http show Response;
import 'package:medica_app/core/helpers/fcm_helper.dart';
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/core/models/user_data_model.dart';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/auth/data/models/login_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/register_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/resetpassword_request_model.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;
  AuthRepoImpl(this.apiService);
  @override
  Future<UserModel> login(LoginRequestModel loginRequest) async {
    try {
      String? fcmToken = await FcmHelper.getToken();
      Map<String, dynamic> loginData = loginRequest.toJson();
      loginData['fcm_token'] = fcmToken;
      final Response = await apiService.post('auth/login', loginData);
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
      String? fcmToken = await FcmHelper.getToken();
      Map<String, String> registerData = registerRequest.toMap();
      registerData['fcm_token'] = fcmToken!;
      // الـ apiService هون بترجع Map جاهز (لأنها نادت _handleResponse داخلياً)
      final responseData = await apiService.postMultipart(
        endpoint: 'auth/register',
        fields: registerData,
        File: registerRequest.profileImage,
        fileKey: 'profile',
      );

      // بما إن الـ ApiService بترمي Exception إذا الـ status كود مو 200
      // فإذن بمجرد وصولنا لهون يعني العملية نجحت والبيانات Map
      return UserModel.fromJson(responseData);
    } catch (e) {
      // طباعة الخطأ الحقيقي لنعرف إذا السيرفر رفض شي (مثل gender)
      print("REGISTER_ERROR_LOG: $e");
      rethrow;
    }
  }
  ///////////إعادة تعيين كلمة المرور

  @override
  Future<UserModel> resetPassword(
    ResetpasswordRequestModel resetpassReuest,
  ) async {
    try {
      final response = await apiService.post(
        'auth/reset-password',
        resetpassReuest.toJson(),
      );
      if (response['data'] == null) {
        return UserModel(
          success: response['success'] ?? true,
          message: response['message'] ?? "",
          token: "",
          userData: UserDataModel.empty(),
          patientData: PatientDataModel.empty(),
        );
      }
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  ///////////تسجيل الخروج (مضافة للدمج)

  @override
  Future<void> logout() async {
    try {
      await apiService.post('auth/logout', {});
    } catch (e) {
      rethrow;
    }
  }
}
