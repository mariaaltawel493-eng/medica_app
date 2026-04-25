part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocState {}

final class ProfileBlocInitial extends ProfileBlocState {}

class ProfileLoading extends ProfileBlocState {}

//نجاح جلب البيانات
class ProfileSuccess extends ProfileBlocState {
  final UserModel userModel;
  ProfileSuccess(this.userModel);
}

///نجاح عملية تعديل المعلومات
class ProfileUpdateSuccess extends ProfileBlocState {
  final message;
  ProfileUpdateSuccess(this.message);
}

class ProfileError extends ProfileBlocState {
  final String message;
  ProfileError(this.message);
}
