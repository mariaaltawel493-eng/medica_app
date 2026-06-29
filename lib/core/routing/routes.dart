class Routes {
  static const String SplashScreen = "/";
  static const String OnboardingScreen = "/onboarding";
  static const String LoginScreen = "/login";

  static const String MainScreen = "/mainscreen";

  static const String RegisterPhoneScreen = "/register_phone";
  static const String RegisterOtpView = "/register_otp";
  static const String RegisterPasswordScreen = "/regi_password";
  static const String FillProfilScreen = "/fill_profile";
  static const String ForgotPasswordScreen = "/reset_password";
  static const String ResetOtpScreen = "/otp_reset";
  static const String NewPassScreen = "/new_password";

  static const String ProfileScreen = "/profile_screen";
  static const String EditProfileScreen = "/edit_profile";
  static const String ChangePasswordScreen = '/change_password';
  // ── شاشات السجل الطبي ──────────────────────────────────────────
  static const String MedicalRecordsScreen = '/Medical_record';

  /// الشاشة الجديدة الأولى: تعديل الملف البدني ومعلومات الطوارئ
  static const String EditPhysicalProfileScreen = '/edit_physical_profile';

  /// الشاشة الجديدة الثانية: تعديل الحالة الصحية (الحساسية والأمراض)
  // ignore: constant_identifier_names
  static const String EditHealthStatusScreen = '/edit_health_status';
  static const String UploadDocumentScreen = '/upload_document';
  static const String ChatBotScreen = '/ChatBot';

  // ── شاشات العيادات والأطباء (مضافة للدمج) ─────────────────────
  static const String HospitalsScreen = '/hospitals';
  static const String AllDoctorsScreen = '/all_doctors';
}
