import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/fcm_helper.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/core/routing/App_router.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/theme/app_theme.dart';
import 'package:medica_app/features/discover/Home/logic/home_bloc/home_bloc_bloc.dart';
import 'package:medica_app/features/notifications/general/logic/notifications_bloc/notifications_bloc.dart'; // 🌟 استيراد البلوك
import 'package:medica_app/features/user/auth/data/repos/auth_repoImp.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
import 'package:medica_app/features/user/settings/language/cubit/language_cubit.dart';
import 'package:medica_app/features/user/settings/theme/theme_cubit/theme_cubit.dart';
import 'package:medica_app/firebase_options.dart';

bool isLoggedIn = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 1. تهيئة فايربيس أولاً وقبل كل شيء
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. تجهيز الـ Service Locator (حقن التبعيات) قبل استخدام أي مساعدات تعتمد عليها
  setupServiceLocator();

  // 3. فحص التوكن المحلي
  String? userToken = await SharedPrefHelper.getData('user_token');
  print("User Token in Main: $userToken");
  if (userToken != null && userToken.isNotEmpty) {
    isLoggedIn = true;
  }

  // 4. تهيئة الـ FCM بعد جهوزية النظام الأساسي
  try {
    await FcmHelper.initFcm();
    String? testToken = await FcmHelper.getToken();
    print("🔑 TEST FCM TOKEN: $testToken");
  } catch (e) {
    print("FCM Init Error: $e");
  }

  final apiService = ApiService();
  final authRepo = AuthRepoImpl(apiService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(create: (context) => AuthBlocBloc(authRepo)),

        BlocProvider<ProfileBlocBloc>(
          create: (context) => getIt<ProfileBlocBloc>(),
        ),

        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>()..loadTheme(),
        ),

        BlocProvider<LanguageCubit>(
          create: (context) => getIt<LanguageCubit>(),
        ),

        BlocProvider<MedicalRecordsBloc>(
          create: (context) => getIt<MedicalRecordsBloc>(),
        ),

        BlocProvider<HomeBlocBloc>(
          create: (context) => getIt<HomeBlocBloc>()..add(FetchHomeDataEvent()),
        ),

        // 🌟 تم إضافة البلوك هنا لضمان عمل الـ History وتحديث البيانات حياً في الخلفية
        BlocProvider<NotificationsBloc>(
          create: (context) => getIt<NotificationsBloc>(),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: "/",
        );
      },
    );
  }
}
