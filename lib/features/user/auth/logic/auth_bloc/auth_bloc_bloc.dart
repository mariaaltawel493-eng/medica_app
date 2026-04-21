import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/features/user/auth/data/models/login_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/register_request_model.dart';
import 'package:medica_app/features/user/auth/data/models/resetpassword_request_model.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repo.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repoImp.dart';
import 'package:meta/meta.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthRepo authRepo;

  String? phoneNumber;
  String? otpcode;
  String? password;
  AuthBlocBloc(this.authRepo) : super(AuthBlocInitial()) {
    //عند استقبال حدث تسجيل الدخول
    on<LoginSubmittedEvent>((event, emit) async {
      //1.حالة Loading
      emit(AuthBlocLoading());
      try {
        final UserModel = await authRepo.login(event.loginRequest);
        if (UserModel.success) {
          emit(AuthBlocSuccess(UserModel));
        } else {
          emit(AuthBlocError(UserModel.message));
        }
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });
    ////////Register///////////
    ///1.صفحة رقم الهاتف
    on<RegisterPhoneSubmitted>((event, emit) async {
      emit(AuthBlocLoading());
      try {
        await authRepo.sendOtp(phone: event.phoneNumber, type: event.type);
        phoneNumber = event.phoneNumber; //حفظ الرقم المخزن
        emit(RegisterPhoneSuccess());
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });

    ///2.صفحة ال otp
    on<RegisterOtpVerified>((event, emit) async {
      emit(AuthBlocLoading());
      try {
        await authRepo.verifyOtp(
          phone: phoneNumber!,
          code: event.otpCode,
          type: event.type,
        );
        emit(RegisterOtpsuccess());
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });
    ////3.صفحة كلمة السر
    on<RegisterPassword>((event, emit) {
      emit(AuthBlocLoading());
      try {
        password = event.password;
        emit(RegisterPasswordSuccess());
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });
    ////4.المرحلة الأخيرة
    on<RegisterFinalSubmitted>((event, emit) async {
      emit(AuthBlocLoading());
      try {
        final Request = RegisterRequestModel(
          firstName: event.firstName,
          lastName: event.lastName,
          phone: phoneNumber!,
          email: event.email,
          password: password!,
        );
        final user = await authRepo.register(Request);
        emit(AuthBlocSuccess(user));
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });

    /////////إعادة تعيين كلمة المرور
    on<ResetPasswordSubmitted>((event, emit) async {
      emit(AuthBlocLoading());
      try {
        final request = ResetpasswordRequestModel(
          phoneNumber!, // عم نستخدم الرقم المخزن من أول خطوة
          event.code!,
          event.Password,
          event.confirmPassword,
        );

        final user = await authRepo.resetPassword(request);

        if (user.success) {
          emit(ResetPasswordSuccess());
        } else {
          emit(AuthBlocError(user.message));
        }
      } catch (e) {
        emit(AuthBlocError(e.toString()));
      }
    });
  }
}
