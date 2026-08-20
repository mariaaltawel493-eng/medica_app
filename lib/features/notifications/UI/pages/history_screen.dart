import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/discover/Home/UI/widgets/error_view.dart';
import 'package:medica_app/features/notifications/general/logic/notifications_bloc/notifications_bloc.dart';
// import 'path_to_error_view/error_view.dart'; // استيراد ويدجت الخطأ الخاصة بكِ

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialNotifications() {
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsBloc>().add(FetchMoreNotificationsEvent());
    }
  }

  int _getNotificationTabIndex(String? type) {
    switch (type?.toLowerCase()) {
      case 'medication_reminder':
      case 'medicine':
        return 0;
      case 'monitoring_reminder':
      case 'vital':
        return 1;
      case 'appointment_reminder':
        return 2;
      default:
        return 0;
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'appointment_reminder':
        return Icons.calendar_month_rounded;
      case 'medication_reminder':
      case 'medicine':
        return Icons.medical_services_rounded;
      case 'monitoring_reminder':
      case 'vital':
        return Icons.bar_chart_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconBackgroundColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'appointment_reminder':
        return const Color(0xFF1E3A5F);
      case 'medication_reminder':
      case 'medicine':
        return const Color(0xFF3E2D1A);
      case 'monitoring_reminder':
      case 'vital':
        return const Color(0xFF3F1D24);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  Color _getIconColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'appointment_reminder':
        return const Color(0xFF2196F3);
      case 'medication_reminder':
      case 'medicine':
        return const Color(0xFFFF9800);
      case 'monitoring_reminder':
      case 'vital':
        return const Color(0xFFE91E63);
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime? sentAt) {
    if (sentAt == null) return '';
    try {
      final difference = DateTime.now().difference(sentAt);
      if (difference.inMinutes < 60) {
        return "notification.time_minutes".tr(
          args: [difference.inMinutes.toString()],
        );
      }
      if (difference.inHours < 24) {
        return "notification.time_hours".tr(
          args: [difference.inHours.toString()],
        );
      }
      return "notification.time_yesterday".tr();
    } catch (_) {
      return "notification.time_some_time".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.darkscaffoldBackground
        : AppColors.scaffoldBackground;
    final cardColor = isDarkMode ? const Color(0xFF1A1F2E) : Colors.white;
    final textPrimary =
        isDarkMode ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDarkMode ? AppColors.darktextSecondary : AppColors.textSecondary;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "notification.history".tr(),
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(
                    MarkAllNotificationsAsReadEvent(),
                  );
            },
            icon: Icon(Icons.done_all_rounded, color: textPrimary),
            tooltip: 'notification.mark_all_as_read'.tr(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadInitialNotifications(),
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsInitialState ||
                state is NotificationsLoadingState) {
              return const Center(child: AppLoadingIndicator());
            }

            // 🌟 استخدمنا الـ ErrorView حصرياً هنا في حالة الخطأ (مثل انقطاع الإنترنت)
            if (state is NotificationsErrorState) {
              return ErrorView(
                message: state.message.contains('connection') ||
                        state.message.contains('Network')
                    ? "notification.network_error".tr()
                    : state.message,
                onRetry: _loadInitialNotifications,
              );
            }

            if (state is NotificationsSuccessState) {
              // 🌟 تركت هذه الحالة تماماً كما كانت في الكود الأصلي الخاص بكِ بدون أي تعديل
              if (state.notifications.isEmpty) {
                return Center(
                  child: Text(
                    "notification.no_notifications".tr(),
                    style: TextStyle(color: textSecondary, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: !state.hasMore
                    ? state.notifications.length
                    : state.notifications.length + 1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: AppLoadingIndicator()),
                    );
                  }

                  final notification = state.notifications[index];
                  final isUnread = !notification.isRead;
                  final tabIndex = _getNotificationTabIndex(notification.type);
                  return GestureDetector(
                    onTap: () {
                      if (isUnread) {
                        context.read<NotificationsBloc>().add(
                              MarkNotificationAsReadEvent(notification.id),
                            );
                      }

                      Navigator.pushNamed(
                        context,
                        Routes.MyActivityScreen,
                        arguments: tabIndex,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isUnread
                              ? AppColors.primary.withOpacity(0.4)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _getIconBackgroundColor(notification.type),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getNotificationIcon(notification.type),
                              color: _getIconColor(notification.type),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 15,
                                          fontWeight: isUnread
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatTime(
                                        notification.sentAt != null
                                            ? DateTime.parse(
                                                notification.sentAt.toString(),
                                              )
                                            : null,
                                      ),
                                      style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 12),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
