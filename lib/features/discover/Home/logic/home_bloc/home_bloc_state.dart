part of 'home_bloc_bloc.dart';

@immutable
sealed class HomeBlocState {}

final class HomeBlocInitial extends HomeBlocState {}

class HomeLoading extends HomeBlocState {}

// حالة النجاح التي تحمل البيانات المكتملة
class HomeSuccess extends HomeBlocState {
  final List<BannerModel> banners;
  final List<TopClinicModel> topClinics;
  final List<TopDoctorModel> topDoctors;

  HomeSuccess({
    required this.banners,
    required this.topClinics,
    required this.topDoctors,
  });
}

class HomeError extends HomeBlocState {
  final String message;
  HomeError(this.message);
}
