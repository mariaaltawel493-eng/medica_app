import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/core/theme/app_theme.dart';
import 'package:medica_app/features/onboarding/onboarding_screen.dart';
import 'package:medica_app/features/onboarding/splash_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/fill_profil_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/forgetpassword_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/home_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/login_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/new_pass_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/registerOtpView.dart';
import 'package:medica_app/features/user/auth/UI/pages/register_password_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/register_phone_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/resetOtp_screen.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repo.dart';
import 'package:medica_app/features/user/auth/data/repos/auth_repoImp.dart';
import 'package:medica_app/features/user/auth/logic/auth_bloc/auth_bloc_bloc.dart';

bool isLoggedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  String? userToken = await SharedPrefHelper.getData('user_token');
  print("User Token in Main:${userToken}");
  if (userToken != null && userToken.isNotEmpty) {
    isLoggedIn = true;
  }

  final apiService = ApiService();
  final authRepo = AuthRepoImpl(apiService);

  runApp(
    // 1. الـ BlocProvider هو الأب ليكون متاحاً في كل مكان
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(create: (context) => AuthBlocBloc(authRepo)),
      ],

      // 2. بداخل الـ child نضع مكتبة الترجمة
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),

        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // إعدادات اللغات
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // إعدادات الثيم
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // يتبع نظام الموبايل
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => RegisterPhoneScreen(),
        '/otp_view': (context) => RegisterOtpView(),
        'regi_password': (context) => RegisterPasswordScreen(),
        'fill_profile': (context) => FillProfilScreen(),
        'reset_password': (context) => ForgotPasswordScreen(),
        "otp_reset": (context) => ResetOtpScreen(),
        "new_pass": (context) => NewPassScreen(),
      },
    );
  }
}
