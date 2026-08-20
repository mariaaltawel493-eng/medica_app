
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_button.dart';
import 'package:medica_app/core/widgets/App_stepper.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';
import 'package:medica_app/features/booking/data/repos/apointements_repo.dart';
import 'package:medica_app/features/booking/logic/book_appointement_cubit/book_appointement_cubit.dart';
import 'package:medica_app/features/booking/ui/pages/my_appointements_screen.dart';
import 'package:medica_app/features/booking/logic/appointements_bloc/appointements_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentFlowScreen extends StatelessWidget {
  final BookAppointmentArgs args;
  const BookAppointmentFlowScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookAppointmentCubit(
        GetIt.I<AppointmentsRepo>(),
        clinicId: args.clinicId,
        doctorId: args.doctorId,
      )..fetchAvailableDates(
          month: DateTime.now().month,
          year: DateTime.now().year,
        ),
      child: _BookAppointmentFlowView(args: args),
    );
  }
}

class _BookAppointmentFlowView extends StatefulWidget {
  final BookAppointmentArgs args;
  const _BookAppointmentFlowView({required this.args});

  @override
  State<_BookAppointmentFlowView> createState() =>
      _BookAppointmentFlowViewState();
}

class _BookAppointmentFlowViewState extends State<_BookAppointmentFlowView> {
  int currentStep = 0; // 0 -> Date/Hour, 1 -> Payment

  List<String> _titles() => ['booking.title'.tr(), 'booking.payments'.tr()];

  void _goNext() => setState(() => currentStep++);
  void _goBack() {
    if (currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: Text(
          _titles()[currentStep],
          style: TextStyle(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppStepper(activeStep: currentStep),
              const SizedBox(height: 10),
              Expanded(child: _buildStepBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody() {
    switch (currentStep) {
      case 0:
        return _DateHourStep(onNext: _goNext);
      case 1:
        return _PaymentStep(doctorName: widget.args.doctorName);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── خطوة 1: اختيار التاريخ والساعة ─────────────────────────────────
class _DateHourStep extends StatefulWidget {
  final VoidCallback onNext;
  const _DateHourStep({required this.onNext});

  @override
  State<_DateHourStep> createState() => _DateHourStepState();
}

class _DateHourStepState extends State<_DateHourStep> {
  DateTime _focusedDay = DateTime.now();

  bool _isDateAvailable(BookAppointmentState state, DateTime day) {
    return state.availableDates.any(
      (d) =>
          d.isAvailable &&
          d.date.year == day.year &&
          d.date.month == day.month &&
          d.date.day == day.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final calendarBgColor =
        isDark ? AppColors.darklightPirmary : AppColors.lightPraimary;
    final textPrimaryColor =
        isDark ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final cubit = context.read<BookAppointmentCubit>();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'booking.select_date'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: calendarBgColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: state.status == BookAppointmentStatus.loadingDates
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      )
                    : TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay:
                            DateTime.now().add(const Duration(days: 365)),
                        focusedDay: _focusedDay,
                        currentDay: DateTime.now(),
                        rowHeight: 38,
                        daysOfWeekHeight: 24,
                        enabledDayPredicate: (day) =>
                            _isDateAvailable(state, day),
                        selectedDayPredicate: (day) {
                          return isSameDay(state.selectedDate, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(state.selectedDate, selectedDay)) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                            cubit.selectDate(selectedDay);
                          }
                        },
                        onPageChanged: (focusedDay) {
                          setState(() => _focusedDay = focusedDay);
                          cubit.fetchAvailableDates(
                            month: focusedDay.month,
                            year: focusedDay.year,
                          );
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            return Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: false,
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                          leftChevronIcon: Icon(
                            Icons.arrow_left,
                            size: 28,
                            color: textSecondaryColor,
                          ),
                          rightChevronIcon: Icon(
                            Icons.arrow_right,
                            size: 28,
                            color: primaryColor,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: textPrimaryColor,
                          ),
                          weekendStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: textPrimaryColor,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration:
                              const BoxDecoration(color: Colors.transparent),
                          todayTextStyle: TextStyle(
                            color: textPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          disabledDecoration:
                              const BoxDecoration(color: Colors.transparent),
                          disabledTextStyle: TextStyle(
                            color: textSecondaryColor.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 32),
              Text(
                'booking.select_hour'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              if (state.status == BookAppointmentStatus.loadingSlots)
                Center(child: CircularProgressIndicator(color: primaryColor))
              else if (state.selectedDate == null)
                Text(
                  'booking.select_date_first'.tr(),
                  style: TextStyle(color: textSecondaryColor),
                )
              else if (state.status == BookAppointmentStatus.failure)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '${'booking.hours_fetch_error'.tr()}:\n'
                    '${state.errorMessage ?? 'booking.unknown_error'.tr()}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else if (state.availableSlots.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'booking.no_hours_available'.tr(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: state.availableSlots.map((slot) {
                    final isSelected = state.selectedTime == slot.time;
                    return ChoiceChip(
                      label: Text(slot.time),
                      selected: isSelected,
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: primaryColor),
                      ),
                      onSelected: slot.isAvailable
                          ? (_) => cubit.selectTime(slot.time)
                          : null,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 30),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: state.canGoToPackageStep ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: !state.canGoToPackageStep,
                  child: AppButton(
                    text: 'booking.next'.tr(),
                    onPressed: widget.onNext,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── خطوة 2: الدفع + تأكيد الحجز مباشرة ─────────────────────────────
class _PaymentStep extends StatefulWidget {
  final String? doctorName;
  const _PaymentStep({this.doctorName});

  @override
  State<_PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<_PaymentStep> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final cardColor =
        isDark ? AppColors.darkcardBackground : AppColors.cardBackground;
    final textPrimaryColor =
        isDark ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state.status == BookAppointmentStatus.success) {
          GetIt.I<AppointmentsBloc>().add(
            FetchAppointmentsEvent(AppointmentStatus.upcoming),
          );
          _showResultDialog(context, success: true);
        } else if (state.status == BookAppointmentStatus.failure) {
          _showResultDialog(
            context,
            success: false,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<BookAppointmentCubit>();
        final isSubmitting = state.status == BookAppointmentStatus.submitting;

        final methods = [
          {'key': 'paypal', 'label': 'booking.paypal'.tr(), 'icon': Icons.paypal},
          {
            'key': 'google_pay',
            'label': 'booking.google_pay'.tr(),
            'icon': Icons.g_mobiledata,
          },
          {'key': 'apple_pay', 'label': 'booking.apple_pay'.tr(), 'icon': Icons.apple},
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'booking.select_payment_method'.tr(),
              style: TextStyle(color: textSecondaryColor),
            ),
            const SizedBox(height: 16),
            ...methods.map((m) {
              final selected = state.selectedPaymentMethod == m['key'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => cubit.selectPaymentMethod(m['key'] as String),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      border: Border.all(
                        color: selected ? primaryColor : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(m['icon'] as IconData, color: primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m['label'] as String,
                            style: TextStyle(color: textPrimaryColor),
                          ),
                        ),
                        Radio<bool>(
                          value: true,
                          groupValue: selected ? true : null,
                          activeColor: primaryColor,
                          onChanged: (_) =>
                              cubit.selectPaymentMethod(m['key'] as String),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('booking.add_new_card'.tr()),
            ),
            const Spacer(),
            if (isSubmitting)
              Center(child: CircularProgressIndicator(color: primaryColor))
            else
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: state.canSubmit ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: !state.canSubmit,
                  child: AppButton(
                    text: 'booking.confirm_booking'.tr(),
                    onPressed: () => cubit.submitBooking(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showResultDialog(
    BuildContext context, {
    required bool success,
    String? message,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? AppColors.darkcardBackground : Colors.white;
    final textPrimaryColor =
        isDark ? AppColors.darktextPrimary : AppColors.textPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darktextSecondary : AppColors.textSecondary;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: cardColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.close,
                color: success ? Colors.green : Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                success
                    ? 'booking.booking_successful'.tr()
                    : 'booking.booking_failed'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                success
                    ? 'booking.booking_success_message'.tr()
                    : message ?? 'booking.booking_failed_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: textSecondaryColor, fontSize: 13),
              ),
              const SizedBox(height: 20),
              if (success)
                AppButton(
                  text: 'booking.ok'.tr(),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                )
              else
                AppButton(
                  text: 'booking.try_again'.tr(),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}