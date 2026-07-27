import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/error_view.dart';
import 'package:medica_app/features/notifications/monitoring/logic/monitoring_reminder_bloc/monitoring_reminder_bloc.dart';
import 'package:medica_app/features/notifications/monitoring/data/models/monitoring_reminder_model.dart';
import 'monitoring_card.dart';
import 'add_reading_dialog.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';

class MonitoringListView extends StatefulWidget {
  const MonitoringListView({super.key});

  @override
  State<MonitoringListView> createState() => _MonitoringListViewState();
}

class _MonitoringListViewState extends State<MonitoringListView> {
  final ScrollController _scrollController = ScrollController();
  List<MonitoringReminderModel> _cachedMonitoringReminders = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 🔄 إذا وصل المستخدم لـ 90% من نهاية السكرول، نجلب المزيد من المؤشرات
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<MonitoringReminderBloc>().add(
        FetchMoreMonitoringRemindersEvent(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 🛠️ دالة مساعدة لتحديد الأيقونة واللون المناسب بناءً على اسم المؤشر القادم من السيرفر
  IconData _getIconForTracker(String trackerName) {
    if (trackerName.toLowerCase().contains('sugar') ||
        trackerName.contains('سكر')) {
      return Icons.water_drop;
    } else if (trackerName.toLowerCase().contains('pressure') ||
        trackerName.contains('ضغط')) {
      return Icons.favorite;
    }
    return Icons.monitor_heart; // افتراضي لمعدل ضربات القلب أو غيره
  }

  Color _getColorForTracker(String trackerName) {
    if (trackerName.toLowerCase().contains('sugar') ||
        trackerName.contains('سكر')) {
      return const Color(0xFF2196F3);
    } else if (trackerName.toLowerCase().contains('pressure') ||
        trackerName.contains('ضغط')) {
      return const Color(0xFFFF5252);
    }
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MonitoringReminderBloc, MonitoringReminderState>(
      listener: (context, state) {
        // 🚨 1. معالجة أخطاء السيرفر والشبكة بالتطابق مع الأدوية
        if (state is MonitoringReminderErrorState) {
          print("error from server: ${state.errorMessage}");

          String errorkey;
          if (state.errorMessage.contains("Network") ||
              state.errorMessage.contains("connection")) {
            errorkey = "errors.no_internet";
          } else if (state.errorMessage.contains("timeout")) {
            errorkey = "errors.timeout";
          } else {
            errorkey = "errors.unknown";
          }

          Appsnackbar.showError(context, errorkey.tr());
        }

        // 🎉 2. نجاح إضافة قراءة جديدة للمؤشر الحيوي
        if (state is LogMonitoringValueSuccessState) {
          Appsnackbar.showSuccess(context, "add_reading_success".tr());
        }
      },
      builder: (context, state) {
        // ⏳ حالة التحميل الأولى
        if (state is MonitoringReminderLoadingState) {
          return const Center(child: AppLoadingIndicator());
        }

        // 💾 تحديث الكاش عند النجاح
        if (state is MonitoringReminderSuccessState) {
          _cachedMonitoringReminders = state.reminders;
        }

        // ❌ حالة الخطأ الكامل (والقائمة فارغة) لعرض الـ ErrorView مع زر إعادة المحاولة
        if (state is MonitoringReminderErrorState &&
            _cachedMonitoringReminders.isEmpty) {
          String errorkey =
              state.errorMessage.contains("Network") ||
                  state.errorMessage.contains("connection")
              ? "errors.no_internet"
              : "errors.unknown";
          return ErrorView(
            message: errorkey.tr(),
            onRetry: () {
              context.read<MonitoringReminderBloc>().add(
                FetchMonitoringRemindersEvent(),
              );
            },
          );
        }

        // 📦 عرض القائمة إذا كانت تحتوي على بيانات حقيقية
        if (_cachedMonitoringReminders.isNotEmpty) {
          return ListView.builder(
            controller: _scrollController,
            itemCount:
                (state is MonitoringReminderSuccessState && state.hasMore)
                ? _cachedMonitoringReminders.length + 1
                : _cachedMonitoringReminders.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // مؤشر تحميل إضافي بالأسفل عند الـ Pagination
              if (index >= _cachedMonitoringReminders.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: AppLoadingIndicator(size: 40)),
                );
              }

              final item = _cachedMonitoringReminders[index];

              return MonitoringCard(
                title: item.trackerName,
                value: "--", // القيمة المبدئية حتى يقوم المستخدم بالقياس
                unit: item.diagnosis ?? "", // استخدام التشخيص أو وحدة مناسبة
                icon: _getIconForTracker(item.trackerName),
                iconColor: _getColorForTracker(item.trackerName),
                lastUpdated: item.reminderTime, // وقت التذكير القادم من السيرفر
                onAddTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddReadingDialog(
                      title: item.trackerName,
                      unit: item.diagnosis ?? "",
                      onSave: (newValue) {
                        // 🚀 إطلاق حدث الـ Bloc الحقيقي لإرسال القياس الجديد للسيرفر
                        context.read<MonitoringReminderBloc>().add(
                          LogMonitoringValueEvent(
                            reminderId: item.id,
                            value: newValue,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }

        // 📭 حالة القائمة الفارغة من السيرفر
        if (state is MonitoringReminderSuccessState &&
            _cachedMonitoringReminders.isEmpty) {
          return ErrorView(
            message: "notification.no_monitoring_today"
                .tr(), // تأكدي من إضافة المفتاح بملف الترجمة
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
