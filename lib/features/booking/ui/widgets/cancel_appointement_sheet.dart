import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_button.dart';
import 'package:medica_app/features/booking/logic/appointements_bloc/appointements_bloc.dart';

List<String> _cancelReasons() => [
  'cancel_appointment.reason_1'.tr(),
  'cancel_appointment.reason_2'.tr(),
  'cancel_appointment.reason_3'.tr(),
  'cancel_appointment.reason_4'.tr(),
  'cancel_appointment.reason_5'.tr(),
];

Future<void> showCancelAppointmentFlow(
  BuildContext context, {
  required int appointmentId,
  required VoidCallback onCancelledSuccessfully,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => BlocProvider.value(
      value: BlocProvider.of<AppointmentsBloc>(context),
      child: _CancelAppointmentSheetContent(
        appointmentId: appointmentId,
        parentContext: context,
        onCancelledSuccessfully: onCancelledSuccessfully,
      ),
    ),
  );
}

class _CancelAppointmentSheetContent extends StatefulWidget {
  final int appointmentId;
  final BuildContext parentContext;
  final VoidCallback onCancelledSuccessfully;

  const _CancelAppointmentSheetContent({
    required this.appointmentId,
    required this.parentContext,
    required this.onCancelledSuccessfully,
  });

  @override
  State<_CancelAppointmentSheetContent> createState() =>
      _CancelAppointmentSheetContentState();
}

class _CancelAppointmentSheetContentState
    extends State<_CancelAppointmentSheetContent> {
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final bgColor = isDark ? AppColors.darkcardBackground : Colors.white;
    final textPrimaryColor = isDark
        ? AppColors.darktextPrimary
        : AppColors.textPrimary;

    return BlocListener<AppointmentsBloc, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentCancelling) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
                Center(child: CircularProgressIndicator(color: primaryColor)),
          );
        } else if (state is AppointmentCancelSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();

          if (widget.parentContext.mounted) {
            _showSuccessDialog(widget.parentContext);
          }
        } else if (state is AppointmentCancelError) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'cancel_appointment.reason_title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              ..._cancelReasons().map(
                (reason) => RadioListTile<String>(
                  value: reason,
                  groupValue: selectedReason,
                  activeColor: primaryColor,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    reason,
                    style: TextStyle(fontSize: 14, color: textPrimaryColor),
                  ),
                  onChanged: (v) => setState(() => selectedReason = v),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'cancel_appointment.submit'.tr(),
                onPressed: selectedReason == null
                    ? () {}
                    : () => _showConfirmDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final bgColor = isDark ? AppColors.darkcardBackground : Colors.white;
    final textSecondaryColor = isDark
        ? AppColors.darktextSecondary
        : AppColors.textSecondary;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'cancel_appointment.confirm_title'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'cancel_appointment.confirm_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: textSecondaryColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('cancel_appointment.back'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AppointmentsBloc>().add(
                          CancelAppointmentEvent(
                            widget.appointmentId,
                            reason: selectedReason,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('cancel_appointment.yes_cancel'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext outerContext) {
    final isDark = Theme.of(outerContext).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final bgColor = isDark ? AppColors.darkcardBackground : Colors.white;
    final textSecondaryColor = isDark
        ? AppColors.darktextSecondary
        : AppColors.textSecondary;

    showDialog(
      context: outerContext,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: primaryColor,
                child: const Icon(Icons.check, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                'cancel_appointment.success_title'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'cancel_appointment.success_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: textSecondaryColor),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'cancel_appointment.ok'.tr(),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  widget.onCancelledSuccessfully();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
