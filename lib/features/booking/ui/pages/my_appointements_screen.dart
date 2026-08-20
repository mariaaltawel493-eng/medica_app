
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/logic/appointements_bloc/appointements_bloc.dart';
import 'package:medica_app/features/booking/ui/widgets/appointement_card.dart';
import 'package:medica_app/features/booking/ui/widgets/cancel_appointement_sheet.dart';
import 'package:medica_app/features/discover/Clinics/data/models/doctor_model.dart';
import 'package:medica_app/features/user/reviews/UI/review_screen.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AppointmentsBloc>(),
      child: const _MyAppointmentsView(),
    );
  }
}

class _MyAppointmentsView extends StatefulWidget {
  const _MyAppointmentsView();

  @override
  State<_MyAppointmentsView> createState() => _MyAppointmentsViewState();
}

class _MyAppointmentsViewState extends State<_MyAppointmentsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _statuses = [
    AppointmentStatus.upcoming,
    AppointmentStatus.completed,
    AppointmentStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchCurrentTab();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _fetchCurrentTab();
    });
  }

  void _fetchCurrentTab() {
    context.read<AppointmentsBloc>().add(
          FetchAppointmentsEvent(_statuses[_tabController.index]),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkscaffoldBackground : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkscaffoldBackground : AppColors.scaffoldBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
        ),
        title: Text(
          'my_appointments.title'.tr(),
          style: TextStyle(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          Icon(Icons.search, color: textSecondaryColor),
          const SizedBox(width: 12),
          Icon(Icons.more_horiz, color: textSecondaryColor),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: textSecondaryColor,
          indicatorColor: primaryColor,
          tabs: [
            Tab(text: 'my_appointments.upcoming'.tr()),
            Tab(text: 'my_appointments.completed'.tr()),
            Tab(text: 'my_appointments.cancelled'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _statuses.map((status) => _AppointmentsTabBody(status: status)).toList(),
      ),
    );
  }
}

class _AppointmentsTabBody extends StatelessWidget {
  final AppointmentStatus status;
  const _AppointmentsTabBody({required this.status});

  Future<void> _openReview(
    BuildContext context,
    AppointmentModel appointment,
  ) async {
    final doctor = DoctorModel(
      id: appointment.doctorId,
      name: appointment.doctorName ?? 'Doctor',
      specialization: '',
      rating: 0,
      consultationFee: (appointment.price ?? 0).toDouble(),
      profile: appointment.doctorImageUrl,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ReviewScreen(appointmentId: appointment.id, doctor: doctor),
      ),
    );

    if (context.mounted) {
      context.read<AppointmentsBloc>().add(
            FetchAppointmentsEvent(AppointmentStatus.completed),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final textPrimaryColor =
        isDark ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    return BlocBuilder<AppointmentsBloc, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoading || state is AppointmentsInitial) {
          return const Center(child: AppLoadingIndicator());
        }

        if (state is AppointmentsError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: textPrimaryColor),
            ),
          );
        }

        if (state is AppointmentsEmpty) {
          return _EmptyState(status: status);
        }

        if (state is AppointmentsLoaded) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              context.read<AppointmentsBloc>().add(
                    FetchAppointmentsEvent(status),
                  );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final appointment = state.appointments[index];
                return AppointmentCard(
                  appointment: appointment,
                  onCancel: () => showCancelAppointmentFlow(
                    context,
                    appointmentId: appointment.id,
                    onCancelledSuccessfully: () => context
                        .read<AppointmentsBloc>()
                        .add(FetchAppointmentsEvent(status)),
                  ),
                  onReschedule: () => Navigator.pushNamed(
                    context,
                    Routes.BookAppointmentScreen,
                    arguments: BookAppointmentArgs(
                      clinicId: appointment.clinicId,
                      doctorId: appointment.doctorId,
                      doctorName: appointment.doctorName,
                      doctorImageUrl: appointment.doctorImageUrl,
                    ),
                  ),
                  onBookAgain: () => Navigator.pushNamed(
                    context,
                    Routes.BookAppointmentScreen,
                    arguments: BookAppointmentArgs(
                      clinicId: appointment.clinicId,
                      doctorId: appointment.doctorId,
                      doctorName: appointment.doctorName,
                      doctorImageUrl: appointment.doctorImageUrl,
                    ),
                  ),
                  onLeaveReview: () => _openReview(context, appointment),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppointmentStatus status;
  const _EmptyState({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimaryColor =
        isDark ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 90,
              color: textSecondaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'my_appointments.empty_title'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'my_appointments.empty_desc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondaryColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// آرغيومنتس شاشة الحجز — تُمرَّر عبر Navigator.pushNamed
class BookAppointmentArgs {
  final int clinicId;
  final int doctorId;
  final String? doctorName;
  final String? doctorImageUrl;

  const BookAppointmentArgs({
    required this.clinicId,
    required this.doctorId,
    this.doctorName,
    this.doctorImageUrl,
  });
}
