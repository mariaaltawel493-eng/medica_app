import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import '../widgets/medication_card.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/error_view.dart';

// استيراد الـ Bloc والـ Events والـ States الخاصة بالأدوية
import 'package:medica_app/features/notifications/medication/logic/medication_reminder_bloc/medication_reminder_bloc.dart';

class ListMedicineScreen extends StatefulWidget {
  const ListMedicineScreen({super.key});

  @override
  State<ListMedicineScreen> createState() => _ListMedicineScreenState();
}

class _ListMedicineScreenState extends State<ListMedicineScreen> {
  // 🎨 الألوان المعتمدة بشكل متناوب ومتناسق مع تصميم التطبيق
  final List<Color> _availableColors = [
    const Color(0xFF29B6F6), // الأزرق
    const Color(0xFFFF7043), // البرتقالي
    const Color(0xFFFFCA28), // الأصفر
    const Color(0xFFEC407A), // الوردي
    const Color(0xFF66BB6A), // الأخضر
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎯 حقن وتوفير الـ Bloc للشاشة عبر الـ getIt مباشرة مع استدعاء حدث الجلب فوراً
    return BlocProvider(
      create: (context) =>
          getIt<MedicationReminderBloc>()..add(FetchMedicationRemindersEvent()),
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "notification.List Medicine".tr(),
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darktextPrimary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // 1️⃣ قائمة الأدوية الديناميكية المربوطة بالـ Bloc مع خاصية السحب للتحديث
              Expanded(
                child: BlocBuilder<MedicationReminderBloc, MedicationReminderState>(
                  builder: (context, state) {
                    if (state is MedicationReminderLoadingState) {
                      return const Center(child: AppLoadingIndicator());
                    }

                    if (state is MedicationReminderErrorState) {
                      return ErrorView(
                        message: "errors.no_internet".tr(),
                        onRetry: () {
                          context.read<MedicationReminderBloc>().add(
                            FetchMedicationRemindersEvent(),
                          );
                        },
                      );
                    }

                    if (state is MedicationReminderSuccessState) {
                      final reminders = state.reminders;

                      if (reminders.isEmpty) {
                        return Center(
                          child: Text(
                            "notification.no_medications_today".tr(),
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      // إضافة RefreshIndicator للسحب وتحديث البيانات فوراً
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          context.read<MedicationReminderBloc>().add(
                            FetchMedicationRemindersEvent(),
                          );
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                        },
                        child: ListView.builder(
                          itemCount: reminders.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemBuilder: (context, index) {
                            final reminder = reminders[index];
                            final Color assignedColor =
                                _availableColors[index %
                                    _availableColors.length];

                            return MedicationCard(
                              medicineName: reminder.medicationName,
                              dosage:
                                  reminder.dosage ??
                                  "notification.as_directed".tr(),
                              time: reminder.reminderTimes.isNotEmpty
                                  ? reminder.reminderTimes.first
                                  : "--:--",
                              instruction: reminder.notes ?? "",
                              cardColor: assignedColor,
                              isTaken:
                                  false, // 🎯 لمنع السحب لتكون واجهة استعراض فقط
                              onSwiped: () {},
                              reminder: reminder,
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // 2️⃣ زر إضافة دواء جديد المعتمد على الـ AppButton
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 10),
                child: AppButton(
                  text: "notification.Add new medicine".tr(),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.CreateNewMedicineScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
