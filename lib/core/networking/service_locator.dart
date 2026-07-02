import 'package:http/http.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/articles/data/repos/articles_repo.dart';
import 'package:medica_app/features/articles/data/repos/articles_repo_imp.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';
import 'package:medica_app/features/discover/Clinics/logic/dictors_details_bloc/doctor_details_bloc.dart';
import 'package:medica_app/features/discover/Home/data/repos/home_repo.dart';
import 'package:medica_app/features/discover/Home/data/repos/home_repoImp.dart';
import 'package:medica_app/features/discover/Home/logic/home_bloc/home_bloc_bloc.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo_imp.dart';
import 'package:medica_app/features/discover/clinics/logic/doctors_bloc/doctors_bloc.dart';
import 'package:medica_app/features/discover/clinics/logic/hospitals_bloc/hospitals_bloc.dart';
import 'package:medica_app/features/discover/clinics/logic/specializations_bloc/specializations_bloc.dart';
import 'package:medica_app/features/notifications/general/data/repos/notifications_repo.dart';
import 'package:medica_app/features/notifications/general/data/repos/notifications_repo_imp.dart';
import 'package:medica_app/features/notifications/general/logic/notifications_bloc/notifications_bloc.dart';
import 'package:medica_app/features/user/chatBot/data/repos/chat_bot_repo.dart';
import 'package:medica_app/features/user/chatBot/data/repos/chat_bot_repo_imp.dart';
import 'package:medica_app/features/user/chatBot/logic/chat_bot_bloc/chat_bot_bloc.dart';
import 'package:medica_app/features/user/medical_records/data/repos/medical_records_repo.dart';
import 'package:medica_app/features/user/medical_records/data/repos/medical_records_repoImp.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
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

  // Repositories
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImp(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<MedicalRecordsRepo>(
    () => MedicalRecordsRepoImp(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatBotRepo>(
    () => ChatBotRepoImp(getIt<ApiService>()),
  );
  // ── Clinics Repository
  getIt.registerLazySingleton<ClinicsRepo>(
    () => ClinicsRepoImp(getIt<ApiService>()),
  );
  // ── Articles Repository
  getIt.registerLazySingleton<ArticlesRepo>(
    () => ArticlesRepoImp(getIt<ApiService>()),
  );
  // Notifications
  getIt.registerLazySingleton<NotificationsRepo>(
    () => NotificationsRepoImpl(getIt<ApiService>()),
  );

  // theme
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<ApiService>()),
  );
  // language
  getIt.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoimp(getIt<ApiService>()));

  getIt.registerFactory(() => ProfileBlocBloc(getIt<ProfileRepo>()));
  getIt.registerFactory(() => ChatBotBloc(getIt<ChatBotRepo>()));
  getIt.registerFactory(() => MedicalRecordsBloc(getIt<MedicalRecordsRepo>()));
  getIt.registerFactory(() => HomeBlocBloc(getIt<HomeRepo>()));

  // ── Clinics BLoCs
  getIt.registerFactory(() => HospitalsBloc(getIt<ClinicsRepo>()));
  getIt.registerFactory(() => SpecializationsBloc(getIt<ClinicsRepo>()));
  getIt.registerFactory(() => DoctorsBloc(getIt<ClinicsRepo>()));
  getIt.registerFactory(() => DoctorDetailsBloc(getIt<ClinicsRepo>()));

  // ── Articles BLoC
  getIt.registerFactory(() => ArticlesBloc(getIt<ArticlesRepo>()));
  //Notifications
  getIt.registerFactory(() => NotificationsBloc(getIt<NotificationsRepo>()));
}
