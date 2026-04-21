import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/features/user/auth/data/models/login_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/register_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/resetpassword_request_model.dart';

abstract class AuthRepo {
  Future<UserModel> login(LoginRequestModel loginRequest);
  Future<void> sendOtp({required String phone, required String type});
  Future<void> verifyOtp({
    required String phone,
    required String code,
    required String type,
  });

  Future<UserModel> register(RegisterRequestModel registerRequest);
  Future<UserModel> resetPassword(ResetpasswordRequestModel resetpassReuest);
}
