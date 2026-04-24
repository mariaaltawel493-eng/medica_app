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
class UpdateImageEvent extends ProfileBlocEvent {
  final File imageFile;
  UpdateImageEvent(this.imageFile);
}

//4.حدث تحديث ؤقم الهاتف
class UpdatePhoneEvent extends ProfileBlocEvent {
  final String phomeNumber;
  UpdatePhoneEvent(this.phomeNumber);
}
