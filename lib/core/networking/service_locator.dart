import 'package:http/http.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repo.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repoImp.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/features/user/settings/language/cubit/language_cubit.dart';
import 'package:medica_app/features/user/settings/theme/theme_cubit/theme_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // main service
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  //Repositry
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImp(ApiService()));

  // theme
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<ApiService>()),
  );
  //language
  getIt.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit(getIt<ApiService>()),
  );

  // Bloc منستخدم Factory مشان كل ما نطلب بلوك جديد يعطينا نسخة نظيفة
  getIt.registerFactory(() => ProfileBlocBloc(getIt<ProfileRepo>()));
}
