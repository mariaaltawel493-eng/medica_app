import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/error_view.dart';

import 'package:medica_app/features/notifications/medication/data/models/medication_reminder_model.dart';
import 'package:medica_app/features/notifications/medication/logic/medication_reminder_bloc/medication_reminder_bloc.dart';
import 'medication_card.dart';

import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';

class MedicationListView extends StatefulWidget {
  const MedicationListView({super.key});

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final ScrollController _scrollController = ScrollController();
  List<MedicationReminderModel> _cachedReminders = [];
  Set<String> _currentLoggedSlots = {};

  final List<Color> _availableColors = [
    const Color(0xFF29B6F6), // الأزرق
    const Color(0xFFFF7043), // البرتقالي
    const Color(0xFFFFCA28), // الأصفر
    const Color(0xFFEC407A), // الوردي
    const Color(0xFF66BB6A), // الأخضر
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<MedicationReminderBloc>().add(
        FetchMoreMedicationRemindersEvent(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: BlocConsumer<MedicationReminderBloc, MedicationReminderState>(
            listener: (context, state) {
              if (state is MedicationReminderErrorState) {
                String errorkey = "errors.unknown";
                if (state.errorMessage.contains("Network") ||
                    state.errorMessage.contains("connection")) {
                  errorkey = "errors.no_internet";
                } else if (state.errorMessage.contains("timeout")) {
                  errorkey = "errors.unknown";
                } else if (state.errorMessage.contains("logged")) {
                  errorkey = "notification.medication_already_logged";
                }
                Appsnackbar.showError(context, errorkey.tr());
              }

              if (state is LogMedicationTakenSuccessState) {
                Appsnackbar.showSuccess(
                  context,
                  "notification.medication_taken_logged".tr(),
                );
              }
            },
            builder: (context, state) {
              if (state is MedicationReminderSuccessState) {
                _cachedReminders = state.reminders;
                _currentLoggedSlots = state.loggedTakenSlots;
              }

              if (state is MedicationReminderLoadingState &&
                  _cachedReminders.isEmpty) {
                return const Center(child: AppLoadingIndicator());
              }

              if (state is MedicationReminderErrorState &&
                  _cachedReminders.isEmpty) {
                String errorkey = state.errorMessage.contains("Network")
                    ? "errors.unknown"
                    : "errors.no_internet";
                return ErrorView(
                  message: errorkey.tr(),
                  onRetry: () {
                    context.read<MedicationReminderBloc>().add(
                      FetchMedicationRemindersEvent(),
                    );
                  },
                );
              }

              if (_cachedReminders.isNotEmpty) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      (state is MedicationReminderSuccessState && state.hasMore)
                      ? _cachedReminders.length + 1
                      : _cachedReminders.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index >= _cachedReminders.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: AppLoadingIndicator(size: 40)),
                      );
                    }

                    final reminder = _cachedReminders[index];
                    final Color assignedColor =
                        _availableColors[index % _availableColors.length];
                    final String currentSlot = reminder.reminderTimes.isNotEmpty
                        ? reminder.reminderTimes.first
                        : "09:00";

                    final bool isMedicationTaken = _currentLoggedSlots.contains(
                      "${reminder.id}_$currentSlot",
                    );

                    return MedicationCard(
                      reminder:
                          reminder, // 🎯 تم التمرير هنا بنجاح لحل خطأ الصندوق والـ Argument المفقود
                      medicineName: reminder.medicationName,
                      dosage:
                          reminder.dosage ?? "notification.as_directed".tr(),
                      time: reminder.reminderTimes.isNotEmpty
                          ? reminder.reminderTimes.first
                          : "--:--",
                      instruction: reminder.notes ?? "",
                      cardColor: assignedColor,
                      isTaken: isMedicationTaken,
                      onSwiped: () {
                        context.read<MedicationReminderBloc>().add(
                          LogMedicationTakenEvent(
                            reminderId: reminder.id,
                            timeSlot: currentSlot,
                          ),
                        );
                      },
                    );
                  },
                );
              }

              if (state is MedicationReminderSuccessState &&
                  _cachedReminders.isEmpty) {
                return ErrorView(
                  message: "notification.no_medications_today".tr(),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 24,
            top: 8,
          ),
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, Routes.ListMedicineScreen);
            },
            icon: const Icon(Icons.list_alt, size: 18),
            label: Text(
              "notification.list_medicine".tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              foregroundColor: isDark ? Colors.white70 : Colors.black87,
              side: BorderSide(
                color: isDark ? Colors.white24 : Colors.black12,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
