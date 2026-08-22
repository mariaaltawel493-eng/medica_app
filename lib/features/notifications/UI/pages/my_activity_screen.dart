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

class MyActivityScreen extends StatefulWidget {
  final int initialTabIndex;

  const MyActivityScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // 🛡️ حماية: نضمن أن الرقم لا يتجاوز 1 (لأن التبويبات صارت 2 فقط: 0 و 1)
    int safeIndex = widget.initialTabIndex;
    if (safeIndex > 1) {
      safeIndex = 0;
    }

    _tabController = TabController(
      length: 2, // 🎯 التبويبات صارت 2
      vsync: this,
      initialIndex: safeIndex,
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
      // نستخدم Builder هنا للتأكد من أن الـ context داخل Scaffold يرى الـ BlocProviders
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
              children: [
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
                              Navigator.pushNamed(
                                context,
                                Routes.Historyscreen,
                              );
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
                        ],
                      ),
                    ],
                  ),
                ),
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
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            HorizontalCalendar(onDateSelected: (date) {}),
                            const SizedBox(height: 10),
                            const SizedBox(
                              height: 500,
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
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            HorizontalCalendar(onDateSelected: (date) {}),
                            const SizedBox(height: 10),
                            const SizedBox(
                              height: 500,
                              child: MonitoringListView(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
