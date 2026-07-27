import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/notifications/UI/widgets/horizontal_calendar.dart';
import 'package:medica_app/features/notifications/UI/widgets/medication_list_view.dart';
import 'package:medica_app/features/notifications/UI/widgets/monitoring_list_view.dart';
import 'package:medica_app/features/notifications/medication/logic/medication_reminder_bloc/medication_reminder_bloc.dart';
import 'package:medica_app/features/notifications/monitoring/logic/monitoring_reminder_bloc/monitoring_reminder_bloc.dart';
import '../widgets/appointment_history_card.dart';

class MyActivityScreen extends StatefulWidget {
  // 🌟 إضافة الـ initialTabIndex كـ argument اختياري داخل الـ Constructor
  final int initialTabIndex;

  const MyActivityScreen({
    super.key,
    this.initialTabIndex = 0, // القيمة الافتراضية هي 0 (تبويب الأدوية)
  });

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 🌟 تهيئة الـ TabController مع تمرير الـ index القادم عبر الـ Widget
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.darkscaffoldBackground
        : AppColors.scaffoldBackground;
    final headerColor = AppColors.primary;
    final textPrimaryColor = isDarkMode
        ? AppColors.darktextPrimary
        : AppColors.textPrimary;
    final textSecondaryColor = isDarkMode
        ? AppColors.darktextSecondary
        : AppColors.textSecondary;

    final List<Map<String, dynamic>> dummyAppointments = [
      {
        "day": "12",
        "month": "October",
        "clinic": "General Care",
        "doctor": "Dr. Ahmed Ali",
        "time": "09:30 AM",
        "status": "upcoming",
      },
      {
        "day": "15",
        "month": "October",
        "clinic": "Dental Clinic",
        "doctor": "Dr. Sara Hassan",
        "time": "02:00 PM",
        "status": "completed",
      },
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicationReminderBloc>(
          create: (context) =>
              getIt<MedicationReminderBloc>()
                ..add(FetchMedicationRemindersEvent()),
        ),
        BlocProvider<MonitoringReminderBloc>(
          create: (context) =>
              getIt<MonitoringReminderBloc>()
                ..add(FetchMonitoringRemindersEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            // 🟦 الجزء العلوي الأزرق (Header)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "notification.my_activity".tr(),
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.Historyscreen);
                        },
                        child: Text(
                          "notification.history".tr(),
                          style: TextStyle(
                            color: textSecondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // 📑 الـ Custom Tab Bar المحدث بـ 3 تابات
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: textPrimaryColor,
                    unselectedLabelColor: textSecondaryColor,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: "notification.medication".tr()),
                      Tab(text: "notification.monitoring".tr()),
                      Tab(text: "notification.appointments".tr()),
                    ],
                  ),
                ],
              ),
            ),

            // ⬜️ الجزء السفلي (محتوى القوائم مع إمكانية السحب للتحديث RefreshIndicator)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 💊 التبويب الأول: الأدوية
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      context.read<MedicationReminderBloc>().add(
                        FetchMedicationRemindersEvent(),
                      );
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        HorizontalCalendar(
                          onDateSelected: (date) {
                            print("Selected Date for Medicine: $date");
                          },
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 500, // أو استخدام Expanded حسب حاجة التصميم
                          child: MedicationListView(),
                        ),
                      ],
                    ),
                  ),

                  // 📊 التبويب الثاني: المؤشرات الحيوية
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      context.read<MonitoringReminderBloc>().add(
                        FetchMonitoringRemindersEvent(),
                      );
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        HorizontalCalendar(
                          onDateSelected: (date) {
                            print("Selected Date for Monitoring: $date");
                          },
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 500,
                          child: MonitoringListView(),
                        ),
                      ],
                    ),
                  ),

                  // 📅 التبويب الثالث: المواعيد والحجوزات اليومية
                  RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        HorizontalCalendar(
                          onDateSelected: (date) {
                            print("Selected Date for Appointments: $date");
                          },
                        ),
                        ListView.builder(
                          itemCount: dummyAppointments.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemBuilder: (context, index) {
                            final appointment = dummyAppointments[index];
                            return AppointmentHistoryCard(
                              dateDay: appointment["day"],
                              dateMonth: appointment["month"],
                              clinicName: appointment["clinic"],
                              doctorName: appointment["doctor"],
                              time: appointment["time"],
                              status: appointment["status"],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
