import 'package:flutter/material.dart';
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

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/register_phone':
        return MaterialPageRoute(builder: (_) => RegisterPhoneScreen());
      case '/register_otp':
        return MaterialPageRoute(builder: (_) => RegisterOtpView());
      case '/regi_password':
        return MaterialPageRoute(builder: (_) => RegisterPasswordScreen());
      case '/fill_profile':
        return MaterialPageRoute(builder: (_) => FillProfilScreen());
      case '/forget_password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case '/otp_reset':
        return MaterialPageRoute(builder: (_) => ResetOtpScreen());
      case '/new_password':
        return MaterialPageRoute(builder: (_) => NewPassScreen());

      default:
        return null;
    }
  }
}
