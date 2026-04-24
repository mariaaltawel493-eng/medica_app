import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:medica_app/core/models/user_model.dart';
import 'package:medica_app/features/user/profile/data/models/profileRequestModel.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBlocBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final ProfileRepo profileRepo;
  ProfileBlocBloc(this.profileRepo) : super(ProfileBlocInitial()) {
    on<FetchProfileDataEvent>((event, emit) async {
      emit(ProfileLoding());
      try {
        final userModel = await profileRepo.getprofile();
        if (userModel.success) {
          emit(ProfileSuccess(userModel));
        } else {
          emit(ProfileError(userModel.message));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoding());
      try {
        final userModel = await profileRepo.UpdateProfile(event.requestModel);
        if (userModel.success) {
          emit(ProfileUpdateSuccess(userModel.message));
        } else {
          emit(ProfileError(userModel.message));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateImageEvent>((event, emit) async {
      emit(ProfileLoding());
      try {
        final userModel = await profileRepo.UpdateProfileImage(event.imageFile);
        if (userModel.success) {
          emit(ProfileUpdateSuccess(userModel.message));
        } else {
          emit(ProfileError(userModel.message));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdatePhoneEvent>((event, emit) async {
      try {
        final userModel = await profileRepo.UpdatePhone(event.phomeNumber);
        if (userModel.success) {
          emit(ProfileUpdateSuccess(userModel.message));
        } else {
          emit(ProfileError(userModel.message));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
