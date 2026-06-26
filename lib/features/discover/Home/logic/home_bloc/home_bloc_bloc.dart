import 'package:bloc/bloc.dart';
import 'package:medica_app/features/discover/Home/data/models/banner_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topclinic_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topdoctor_model.dart';
import 'package:medica_app/features/discover/Home/data/repos/home_repo.dart';

import 'package:meta/meta.dart';

part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  final HomeRepo homeRepo;

  HomeBlocBloc(this.homeRepo) : super(HomeBlocInitial()) {
    on<FetchHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        // استدعاء متوازٍ للطلبات الثلاثة
        final results = await Future.wait([
          homeRepo.getBanners(),
          homeRepo.getTopClinics(limit: 2),
          homeRepo.getTopDoctors(limit: 2),
        ]);

        final banners = results[0] as List<BannerModel>;
        final topClinics = results[1] as List<TopClinicModel>;
        final topDoctors = results[2] as List<TopDoctorModel>;

        emit(
          HomeSuccess(
            banners: banners,
            topClinics: topClinics,
            topDoctors: topDoctors,
          ),
        );
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
