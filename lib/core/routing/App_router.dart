import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/features/discover/Clinics/UI/pages/All_doctor_screen.dart';
import 'package:medica_app/features/discover/Clinics/UI/pages/hospitals_screen.dart';
import 'package:medica_app/features/discover/Clinics/logic/dictors_details_bloc/doctor_details_bloc.dart';
import 'package:medica_app/features/discover/Clinics/logic/doctors_bloc/doctors_bloc.dart';
import 'package:medica_app/features/discover/Clinics/logic/hospitals_bloc/hospitals_bloc.dart';
import 'package:medica_app/features/discover/Clinics/logic/specializations_bloc/specializations_bloc.dart';
import 'package:medica_app/features/discover/Home/UI/pages/main_screen.dart';
import 'package:medica_app/features/notifications/UI/pages/create_new_medicine_screen.dart';
import 'package:medica_app/features/notifications/UI/pages/history_screen.dart';

import 'package:medica_app/features/notifications/UI/pages/list_medicine_screen.dart';
import 'package:medica_app/features/notifications/UI/pages/medicine_information_screen.dart';
import 'package:medica_app/features/notifications/UI/pages/my_activity_screen.dart'
    hide HistoryScreen;
import 'package:medica_app/features/notifications/medication/data/models/medication_reminder_model.dart';
import 'package:medica_app/features/notifications/medication/logic/medication_reminder_bloc/medication_reminder_bloc.dart';
import 'package:medica_app/features/onboarding/onboarding_screen.dart';
import 'package:medica_app/features/onboarding/splash_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/fill_profil_screen.dart';
import 'package:medica_app/features/user/auth/UI/pages/forgetpassword_screen.dart';
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
      case Routes.MainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
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
      // ── شاشات العيادات والأطباء (مضافة للدمج) ─────────────────────
      case Routes.HospitalsScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => GetIt.I<HospitalsBloc>()),
              BlocProvider(create: (_) => GetIt.I<SpecializationsBloc>()),
              BlocProvider(create: (_) => GetIt.I<DoctorDetailsBloc>()),
            ],
            child: HospitalsScreen(),
          ),
        );

      case Routes.AllDoctorsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.I<DoctorsBloc>(),
            child: AllDoctorsScreen(),
          ),
        );

      case Routes.MyActivityScreen:
        // 🌟 استخراج الـ index الممرر (إن وجد) وتحويله كـ int
        final tabIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MyActivityScreen(initialTabIndex: tabIndex),
          settings:
              settings, // ضروري لتمرير الـ settings والـ arguments بشكل سليم
        );
      case Routes.MedicineInformationScreen:
        final reminder = settings.arguments as MedicationReminderModel;
        return MaterialPageRoute(
          builder: (_) => MedicineInformationScreen(reminder: reminder),
        );

      case Routes.ListMedicineScreen:
        return MaterialPageRoute(builder: (_) => const ListMedicineScreen());

      case Routes.CreateNewMedicineScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateNewMedicineScreen(),
        );
      case Routes.Historyscreen:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());

      default:
        MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
    return null;
  }
}
