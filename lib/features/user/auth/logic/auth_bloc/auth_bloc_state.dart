part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

class AuthBlocLoading extends AuthBlocState {}

class RegisterPhoneSuccess extends AuthBlocState {} //انقلني لصفحة otp

class RegisterOtpsuccess extends AuthBlocState {} // انقلني لصفحة الباسوورد

class RegisterPasswordSuccess extends AuthBlocState {} //انقلني لصفحة البروفايل

class AuthBlocSuccess extends AuthBlocState {
  final UserModel user; // باخد بيانات المستخدم لاعرض الاسم مثلا
  AuthBlocSuccess(this.user);
}

class ResetPasswordSuccess extends AuthBlocState {} // إعادة تعيين كلمة المرور

class AuthBlocError extends AuthBlocState {
  final String message;
  AuthBlocError(this.message);
}
