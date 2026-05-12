part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocState {}

final class ProfileBlocInitial extends ProfileBlocState {}

class ProfileLoading extends ProfileBlocState {}

//نجاح جلب البيانات
class ProfileSuccess extends ProfileBlocState {
  final Userprofilemodel userprofilemodel;
  ProfileSuccess(this.userprofilemodel);
}

///نجاح عملية تعديل المعلومات
class ProfileUpdateSuccess extends ProfileBlocState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

///////تعدبل الصورة
class UpdateImageLoding extends ProfileBlocState {}

class UpdateImageSuccess extends ProfileBlocState {
  final String message;
  UpdateImageSuccess(this.message);
}

class UpdateImageError extends ProfileBlocState {
  final String error;
  UpdateImageError(this.error);
}

///////تعديل البيانات
class UpdateProfileLoding extends ProfileBlocState {}

class UpdateProfileSuccess extends ProfileBlocState {
  final Userprofilemodel profileData;
  UpdateProfileSuccess(this.profileData);
}

///تحديث الرقم
class sendUpdatePhoneOtpSuccess extends ProfileBlocState {
  final String message;
  sendUpdatePhoneOtpSuccess(this.message);
}

// نجاح تحديث الرقم
class UpdatePhoneSuccess extends ProfileBlocState {
  final String message;
  UpdatePhoneSuccess(this.message);
}

class ProfileError extends ProfileBlocState {
  final String message;
  ProfileError(this.message);
}

// نجاح تحديث كلمة السر
class ChangePasswordSuccess extends ProfileBlocState {
  final String message;
  ChangePasswordSuccess(this.message);
}
