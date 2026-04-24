part of 'profile_bloc_bloc.dart';

@immutable
sealed class ProfileBlocState {}

final class ProfileBlocInitial extends ProfileBlocState {}

class ProfileLoding extends ProfileBlocState {}

class ProfileSuccess extends ProfileBlocState {
  final UserModel userModel;
  ProfileSuccess(this.userModel);
}

class ProfileError extends ProfileBlocState {
  final String message;
  ProfileError(this.message);
}
