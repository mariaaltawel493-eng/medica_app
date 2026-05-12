import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/models/userprofileModel.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBlocBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final ProfileRepo profileRepo;
  ProfileBlocBloc(this.profileRepo) : super(ProfileBlocInitial()) {
    on<FetchProfileDataEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profiledata = await profileRepo.getprofile();
        emit(ProfileSuccess(profiledata));
      } catch (e) {
        print("ERROR IN PROFILE BLOC:$e");
        print("STACKTRACE:$StackTrace");
        emit(ProfileError(e.toString()));
      }
    });
    ////تحديث بيانات البروفايل
    on<UpdateProfileEvent>((event, emit) async {
      emit(UpdateProfileLoding());
      try {
        final response = await profileRepo.UpdateProfile(event.requestModel);
        final newData = await profileRepo.getprofile();

        emit(UpdateProfileSuccess(response));
        emit(ProfileSuccess(newData));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    //// تحديث الصورة
    on<UpdateProfileImageEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final String responsMessage = await profileRepo.UpdateProfileImage(
          event.imageFile,
        );
        emit(UpdateImageSuccess(responsMessage));
        add(FetchProfileDataEvent());
      } catch (e) {
        emit(UpdateImageError(e.toString()));
      }
    });

    /// ارسال ال OTP
    on<sendUpdatePhoneOtpEvent>((event, emit) async {
      emit(UpdateProfileLoding());
      try {
        final message = await profileRepo.sendUpdatePhoneOtp(type: event.type);
        emit(sendUpdatePhoneOtpSuccess(message));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    on<verifyAndUpdatePhoneEvent>((event, emit) async {
      emit(UpdateProfileLoding());
      try {
        final message = await profileRepo.verifyAndUpdatePhone(
          new_phone: event.new_Phone,
          code: event.code,
        );
        emit(UpdatePhoneSuccess(message));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    on<ResentProfileStateEvent>((event, emit) {
      if (state is ProfileError || state is UpdateProfileSuccess) {
        add(FetchProfileDataEvent());
      }
    });

    //// تحديث كلمة السر
    on<ChangePasswordEvent>((event, emit) async {
      emit(UpdateProfileLoding());
      try {
        final message = await profileRepo.changePassword(
          code: event.code,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        );
        emit(ChangePasswordSuccess(message));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
