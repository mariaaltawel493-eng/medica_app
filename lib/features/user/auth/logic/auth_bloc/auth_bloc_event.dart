part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class RegisterPhoneSubmitted extends AuthBlocEvent {
  final String phoneNumber;
  final String type;
  RegisterPhoneSubmitted(this.phoneNumber, this.type);
}

class RegisterOtpVerified extends AuthBlocEvent {
  final String otpCode;
  final String type;
  RegisterOtpVerified(this.otpCode, {required this.type});
}

class RegisterPassword extends AuthBlocEvent {
  final String password;
  RegisterPassword(this.password);
}

class RegisterFinalSubmitted extends AuthBlocEvent {
  final String firstName;
  final String lastName;
  final String email;
  final File? profileImage;
  final String? dateofBirth;
  final String? gender;
  RegisterFinalSubmitted(
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.dateofBirth,
    this.gender,
  );
}

class LoginSubmittedEvent extends AuthBlocEvent {
  final LoginRequestModel loginRequest; // الحدث بيحمل معه البيانات
  LoginSubmittedEvent(this.loginRequest);
}

class ResetPasswordSubmitted extends AuthBlocEvent {
  final String code;
  final String Password;
  final String confirmPassword;
  ResetPasswordSubmitted(this.code, this.Password, this.confirmPassword);
}

class LogoutRequestedEvent extends AuthBlocEvent {}
