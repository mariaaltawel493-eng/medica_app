import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/core/routing/App_router.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/theme/app_theme.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repoImp.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_event.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
import 'package:medica_app/features/user/settings/language/cubit/language_cubit.dart';
import 'package:medica_app/features/user/settings/theme/theme_cubit/theme_cubit.dart';

bool isLoggedIn = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupServiceLocator();
  String? userToken = await SharedPrefHelper.getData('user_token');
  print("User Token in Main:${userToken}");
  if (userToken != null && userToken.isNotEmpty) {
    isLoggedIn = true;
  }

  final apiService = ApiService();
  final authRepo = AuthRepoImpl(apiService);

  ;

  runApp(
    // 1. الـ BlocProvider هو الأب ليكون متاحاً في كل مكان
    MultiBlocProvider(
      providers: [
        //auth
        BlocProvider<AuthBlocBloc>(create: (context) => AuthBlocBloc(authRepo)),
        //profile
        BlocProvider<ProfileBlocBloc>(
          create: (context) => getIt<ProfileBlocBloc>(),
        ),
        //theme
        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>()..loadTheme(),
        ),
        //language
        BlocProvider<LanguageCubit>(
          create: (context) => getIt<LanguageCubit>(),
        ),
        BlocProvider<MedicalRecordsBloc>(
          create: (context) => getIt<MedicalRecordsBloc>(),
        ),
      ],

      // 2. بداخل الـ child نضع مكتبة الترجمة
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),

        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppRouter appRouter = AppRouter();

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,

          // إعدادات اللغات
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // إعدادات الثيم
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode, //صار بياخد قيمة ال state تبع ال cubit
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: "/",
        );
      },
    );
  }
}
