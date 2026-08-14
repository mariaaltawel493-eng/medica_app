import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/booking/data/models/apointement_models.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onBookAgain;
  final VoidCallback? onLeaveReview;
  final VoidCallback? onChannelTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
    this.onBookAgain,
    this.onLeaveReview,
    this.onChannelTap,
  });

  // String get _channelLabel {
  //   switch (appointment.channel) {
  //     case AppointmentChannel.messaging:
  //       return 'my_appointments.messaging'.tr();
  //     case AppointmentChannel.voiceCall:
  //       return 'my_appointments.voice_call'.tr();
  //     case AppointmentChannel.videoCall:
  //       return 'my_appointments.video_call'.tr();
  //     case AppointmentChannel.unknown:
  //       return appointment.type;
  //   }
  // }

  // IconData get _channelIcon {
  //   switch (appointment.channel) {
  //     case AppointmentChannel.messaging:
  //       return Icons.chat_bubble_outline;
  //     case AppointmentChannel.voiceCall:
  //       return Icons.call_outlined;
  //     case AppointmentChannel.videoCall:
  //       return Icons.videocam_outlined;
  //     case AppointmentChannel.unknown:
  //       return Icons.info_outline;
  //   }
  // }

  Color _statusColor(bool isDark) {
    switch (appointment.effectiveStatus) {
      case AppointmentStatus.completed:
        return const Color(0xFF2ECC71);
      case AppointmentStatus.cancelled:
        return const Color(0xFFFF5252);
      case AppointmentStatus.upcoming:
        return isDark ? AppColors.darkprimary : AppColors.primary;
      case AppointmentStatus.unknown:
        return isDark ? AppColors.darktextSecondary : Colors.grey;
    }
  }

  String get _statusLabel {
    switch (appointment.effectiveStatus) {
      case AppointmentStatus.completed:
        return 'my_appointments.completed'.tr();
      case AppointmentStatus.cancelled:
        return 'my_appointments.cancelled'.tr();
      case AppointmentStatus.upcoming:
        return 'my_appointments.upcoming'.tr();
      case AppointmentStatus.unknown:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveStatus = appointment.effectiveStatus;
    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final lightPrimaryColor = isDark
        ? AppColors.darklightPirmary
        : AppColors.lightPraimary;
    final textPrimaryColor = isDark
        ? AppColors.darktextPrimary
        : AppColors.textPrimary;
    final textSecondaryColor = isDark
        ? AppColors.darktextSecondary
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: appointment.doctorImageUrl != null
                    ? Image.network(
                        appointment.doctorImageUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _fallbackAvatar(lightPrimaryColor, primaryColor),
                      )
                    : _fallbackAvatar(lightPrimaryColor, primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName ?? 'Doctor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(
                    //       '$_channelLabel - ',
                    //       style: TextStyle(
                    //         fontSize: 12,
                    //         color: textSecondaryColor,
                    //       ),
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 8,
                    //         vertical: 2,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: _statusColor(isDark).withOpacity(0.12),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: Text(
                    //         _statusLabel,
                    //         style: TextStyle(
                    //           fontSize: 11,
                    //           fontWeight: FontWeight.w600,
                    //           color: _statusColor(isDark),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(appointment.appointmentDate)} | ${appointment.appointmentTime}',
                      style: TextStyle(fontSize: 12, color: textSecondaryColor),
                    ),
                  ],
                ),
              ),
              // InkWell(
              //   onTap: onChannelTap,
              //   child: CircleAvatar(
              //     radius: 18,
              //     backgroundColor: lightPrimaryColor,
              //     child: Icon(_channelIcon, size: 18, color: primaryColor),
              //   ),
              // ),
            ],
          ),
          if (effectiveStatus == AppointmentStatus.upcoming) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _outlinedButton(
                    'my_appointments.cancel_appointment'.tr(),
                    onCancel,
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _filledButton(
                    'my_appointments.reschedule'.tr(),
                    onReschedule,
                    primaryColor,
                  ),
                ),
              ],
            ),
          ],
          if (effectiveStatus == AppointmentStatus.completed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _outlinedButton(
                    'my_appointments.book_again'.tr(),
                    onBookAgain,
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _filledButton(
                    appointment.isReviewed
                        ? 'my_appointments.reviewed'.tr()
                        : 'my_appointments.leave_a_review'.tr(),
                    appointment.isReviewed ? null : onLeaveReview,
                    primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _fallbackAvatar(Color bgColor, Color iconColor) => Container(
    width: 56,
    height: 56,
    color: bgColor,
    child: Icon(Icons.person, color: iconColor),
  );

  Widget _outlinedButton(String text, VoidCallback? onTap, Color color) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _filledButton(String text, VoidCallback? onTap, Color color) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}
