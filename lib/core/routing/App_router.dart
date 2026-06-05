import 'package:flutter/material.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/core/routing/routes.dart';
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
import 'package:medica_app/features/user/chatBot/UI/chatbot_screen.dart';
import 'package:medica_app/features/user/medical_records/UI/pages/edit_health_status_screen.dart';
import 'package:medica_app/features/user/medical_records/UI/pages/edit_physical_profile_screen.dart';
import 'package:medica_app/features/user/medical_records/UI/pages/medical_records_screen.dart';
import 'package:medica_app/features/user/medical_records/UI/pages/upload_document_screen.dart';
import 'package:medica_app/features/user/profile/UI/pages/changepassword_screen.dart';
import 'package:medica_app/features/user/profile/UI/pages/editprofile_screen.dart';
import 'package:medica_app/features/user/profile/UI/pages/profile_screen.dart';
import 'package:medica_app/features/user/profile/data/repos/profile_repoImp.dart';

class AppRouter {
  // تعريف المستودع هون لتوفير استهلاك الذاكرة
  final ProfileRepo = ProfileRepoImp(ApiService());

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.OnboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case Routes.LoginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.HomeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.RegisterPhoneScreen:
        return MaterialPageRoute(builder: (_) => RegisterPhoneScreen());
      case Routes.RegisterOtpView:
        return MaterialPageRoute(builder: (_) => RegisterOtpView());
      case Routes.RegisterPasswordScreen:
        return MaterialPageRoute(builder: (_) => RegisterPasswordScreen());
      case Routes.FillProfilScreen:
        return MaterialPageRoute(builder: (_) => FillProfilScreen());
      case Routes.ForgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case Routes.ResetOtpScreen:
        return MaterialPageRoute(builder: (_) => ResetOtpScreen());
      case Routes.NewPassScreen:
        return MaterialPageRoute(builder: (_) => NewPassScreen());
      case Routes.ProfileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.EditProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.ChangePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case Routes.MedicalRecordsScreen:
        return MaterialPageRoute(builder: (_) => const MedicalRecordsScreen());

      /// ✅ الشاشة الجديدة الأولى: الملف البدني ومعلومات الطوارئ
      /// الاستخدام:
      /// Navigator.pushNamed(
      ///   context, Routes.EditPhysicalProfileScreen,
      ///   arguments: patientDataModel,  // PatientDataModel أو null
      /// );
      case Routes.EditPhysicalProfileScreen:
        return MaterialPageRoute(
          builder: (_) => const EditPhysicalProfileScreen(),
          settings: settings, // ضروري لتمرير arguments للشاشة
        );

      /// ✅ الشاشة الجديدة الثانية: الحساسية والأمراض المزمنة
      /// الاستخدام:
      /// Navigator.pushNamed(
      ///   context, Routes.EditHealthStatusScreen,
      ///   arguments: patientDataModel,  // PatientDataModel أو null
      /// );
      case Routes.EditHealthStatusScreen:
        return MaterialPageRoute(
          builder: (_) => const EditHealthStatusScreen(),
          settings: settings, // ضروري لتمرير arguments للشاشة
        );

      case Routes.UploadDocumentScreen:
        return MaterialPageRoute(builder: (_) => const UploadDocumentScreen());

      case Routes.ChatBotScreen:
        return MaterialPageRoute(builder: (_) => const ChatBotScreen());
      default:
        MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
