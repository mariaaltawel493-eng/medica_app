import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/error_view.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/home_banner_slider.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/home_header.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/home_reminder_banner.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/home_search_bar.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/top_clinics_section.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/top_doctor_section.dart';
import 'package:medica_app/features/discover/Home/logic/home_bloc/home_bloc_bloc.dart';
import 'package:medica_app/features/discover/profile_setup/UI/widgets/profile_setup-bottom_sheet.dart';
import 'package:medica_app/features/notifications/general/logic/notifications_bloc/notifications_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_event.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_state.dart';
import 'package:medica_app/features/user/profile/logic/profile_bloc/profile_bloc_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRemindLater = false;
  bool _hasInteractedThisSession = false;
  // 🔥 متغير جديد لتعقب ما إذا كانت البوتوم شيت مفتوحة حالياً لمنع ظهور البانر معها بنفس اللحظة
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBlocBloc>().add(FetchHomeDataEvent());
    context.read<ProfileBlocBloc>().add(FetchProfileDataEvent());
    context.read<MedicalRecordsBloc>().add(GetMedicalProfileEvent());

    // 🔥 جلب الإشعارات لجلب العداد فوراً عند فتح الـ HomeScreen
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());

    // قراءة الحالة المخزنة عند فتح الشاشة لتحديث البانر مبدئياً
    SharedPrefHelper.isRemindLater().then((value) {
      if (mounted) {
        setState(() => _isRemindLater = value);
      }
    });

    // إظهار الشيت الترحيبي بعد 3 ثوانٍ بذكاء صارم
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      // 🔥 قراءة متزامنة فورية ومباشرة قبل الفحص لمنع العشوائية والتداخل التلقائي
      final bool savedRemindStatus = await SharedPrefHelper.isRemindLater();
      if (!mounted) return;

      final medicalState = context.read<MedicalRecordsBloc>().state;
      final isComplete = medicalState.patientData?.isProfileComplete ?? false;

      if (!isComplete && !savedRemindStatus && !_hasInteractedThisSession) {
        if (mounted) {
          setState(() {
            _hasInteractedThisSession = true;
            _isBottomSheetOpen = true; // الشيت فُتحت الآن
          });
        }

        final result = await showModalBottomSheet<bool>(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const ProfileSetupBottomSheet(),
          ),
        );
        // 🔥 تحديث الحالة فورياً عند الإغلاق: البانر يظهر بلحظتها بناءً على نتيجة الضغط
        if (mounted) {
          setState(() {
            _isBottomSheetOpen = false; // الشيت أُغلقت
            if (result == true) {
              _isRemindLater = true;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: BlocListener<HomeBlocBloc, HomeBlocState>(
        listener: (context, state) {
          if (state is HomeError) {
            Appsnackbar.showError(context, 'errors.no_internet'.tr());
          }
        },
        child: BlocBuilder<HomeBlocBloc, HomeBlocState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: AppLoadingIndicator());
            } else if (state is HomeError) {
              return ErrorView(
                message: 'errors.no_internet'.tr(),
                onRetry: () =>
                    context.read<HomeBlocBloc>().add(FetchHomeDataEvent()),
              );
            } else if (state is HomeSuccess) {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                        builder: (context, profileState) {
                          return BlocBuilder<
                            MedicalRecordsBloc,
                            MedicalRecordsState
                          >(
                            builder: (context, medicalState) {
                              final isComplete =
                                  medicalState.patientData?.isProfileComplete ??
                                  false;

                              // 🔥 الشرط المحكم والذكي لمنع تداخل البانر مع الشيت وظهوره الفوري عند الإغلاق
                              final showBanner =
                                  !isComplete &&
                                  !_isBottomSheetOpen &&
                                  (_isRemindLater || _hasInteractedThisSession);

                              String name = "User";
                              if (profileState is ProfileSuccess) {
                                name =
                                    profileState.userprofilemodel.data.fullName;
                              }
                              final String? qrUrl =
                                  medicalState.patientData?.qrCodeUrl;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showBanner)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 12.0),
                                      child: HomeProfileReminderBanner(),
                                    ),

                                  // 🔥 تغليف الهيدر بـ BlocBuilder للإشعارات لجلب وتمرير العداد
                                  BlocBuilder<
                                    NotificationsBloc,
                                    NotificationsState
                                  >(
                                    builder: (context, notifState) {
                                      int unreadCount = 0;
                                      if (notifState
                                          is NotificationsSuccessState) {
                                        unreadCount = notifState.unreadCount;
                                      }
                                      return HomeHeader(
                                        fullName: name,
                                        unreadCount:
                                            unreadCount, // تمرير العداد هنا
                                        onNotificationPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.MyActivityScreen,
                                          );
                                        },
                                        onQrCodePressed: () {
                                          if (qrUrl != null &&
                                              qrUrl.isNotEmpty) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  'home.my_qr_code'.tr(),
                                                ),
                                                content: SizedBox(
                                                  width: 250,
                                                  height: 250,
                                                  child: QrImageView(
                                                    data: qrUrl,
                                                    version: QrVersions.auto,
                                                    size: 200.0,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            Appsnackbar.showError(
                                              context,
                                              "qr_not_available".tr(),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      HomeSearchBar(
                        onTap: () => Navigator.pushNamed(context, '/search'),
                      ),
                      const SizedBox(height: 24),
                      HomeBannerSlider(banners: state.banners),
                      const SizedBox(height: 24),
                      TopClinicsSection(clinics: state.topClinics),
                      const SizedBox(height: 24),
                      TopDoctorsSection(doctors: state.topDoctors),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
