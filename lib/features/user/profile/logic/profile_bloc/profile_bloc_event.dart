part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocEvent {}

//1. حدث جلب البيانات موجودة مسبقا
class FetchProfileDataEvent extends ProfileBlocEvent {}

//2.حدث تحديث المعلومات
class UpdateProfileEvent extends ProfileBlocEvent {
  final ProfileRequestModel requestModel;
  UpdateProfileEvent(this.requestModel);
}

//3. حدث تحديث الصورة الشخصية
class UpdateProfileImageEvent extends ProfileBlocEvent {
  final File imageFile;
  UpdateProfileImageEvent(this.imageFile);
}

///حدث تحديث الرقم
class sendUpdatePhoneOtpEvent extends ProfileBlocEvent {
  final String type;
  sendUpdatePhoneOtpEvent({required this.type});
}

class verifyAndUpdatePhoneEvent extends ProfileBlocEvent {
  final String new_Phone;
  final String code;
  verifyAndUpdatePhoneEvent(this.new_Phone, this.code);
}

class ResentProfileStateEvent extends ProfileBlocEvent {}

class ChangePasswordEvent extends ProfileBlocEvent {
  final String code;
  final String newPassword;
  final String confirmPassword;
  ChangePasswordEvent(this.code, this.newPassword, this.confirmPassword);
}
