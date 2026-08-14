enum AppointmentStatus { upcoming, completed, cancelled, unknown }

enum AppointmentChannel { messaging, voiceCall, videoCall, unknown }

AppointmentStatus _statusFromString(String? value) {
  switch (value?.toLowerCase().trim()) {
    case 'upcoming':
    case 'confirmed':
    case 'pending':
    case 'scheduled': // ✅ القيمة الفعلية القادمة من السيرفر
      return AppointmentStatus.upcoming;
    case 'completed':
    case 'done':
      return AppointmentStatus.completed;
    case 'cancelled':
    case 'canceled':
      return AppointmentStatus.cancelled;
    default:
      return AppointmentStatus.unknown;
  }
}

AppointmentChannel _channelFromString(String? value) {
  switch (value?.toLowerCase().trim()) {
    case 'messaging':
    case 'chat':
      return AppointmentChannel.messaging;
    case 'voice_call':
    case 'voice':
    case 'call':
      return AppointmentChannel.voiceCall;
    case 'video_call':
    case 'video':
      return AppointmentChannel.videoCall;
    default:
      return AppointmentChannel.unknown;
  }
}

class AppointmentModel {
  final int id;
  final int clinicId;
  final int doctorId;
  final String? doctorName;
  final String? doctorImageUrl;
  final String? clinicName;
  final String? clinicAddress;
  final DateTime appointmentDate;
  final String appointmentTime; // مثال: "09:00"
  final String type; // new / follow_up ...
  final AppointmentStatus status;
  final AppointmentChannel channel;
  final num? price;
  final bool isReviewed;
  final bool canCancel;

  const AppointmentModel({
    required this.id,
    required this.clinicId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.type,
    required this.status,
    this.doctorName,
    this.doctorImageUrl,
    this.clinicName,
    this.clinicAddress,
    this.channel = AppointmentChannel.unknown,
    this.price,
    this.isReviewed = false,
    this.canCancel = true,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctorJson = json['doctor'] is Map
        ? json['doctor'] as Map<String, dynamic>
        : null;
    final clinicJson = json['clinic'] is Map
        ? json['clinic'] as Map<String, dynamic>
        : null;

    return AppointmentModel(
      id: _parseInt(json['id']),
      // ⚠️ حالياً الرد ما فيه doctor_id/clinic_id إطلاقاً — رح تضل 0
      // لحد ما الباك اند يضيفهم بالرد
      clinicId: _parseInt(
        json['clinic_id'] ?? clinicJson?['id'] ?? doctorJson?['clinic_id'],
      ),
      doctorId: _parseInt(json['doctor_id'] ?? doctorJson?['id']),
      doctorName: (doctorJson?['name'] ?? json['doctor_name'])?.toString(),
      doctorImageUrl:
          (doctorJson?['profile'] ??
                  doctorJson?['image'] ??
                  json['doctor_image'])
              ?.toString(),
      clinicName: (clinicJson?['name'] ?? json['clinic_name'])?.toString(),
      clinicAddress: clinicJson?['address']?.toString(),
      appointmentDate: _parseDate(json['appointment_date']),
      appointmentTime: json['appointment_time']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: _statusFromString(json['status']?.toString()),
      channel: _channelFromString(
        (json['channel'] ?? json['consultation_type'])?.toString(),
      ),
      // ✅ السيرفر برجع consultation_fee مش price
      price: json['consultation_fee'] is num
          ? json['consultation_fee'] as num
          : num.tryParse(
              (json['consultation_fee'] ?? json['price'])?.toString() ?? '',
            ),
      isReviewed: json['is_reviewed'] == true || json['reviewed'] == true,
      canCancel: json['can_cancel'] ?? true,
    );
  }

  // ✅ الحقول التي يقبلها فعلياً POST /api/appointments حسب الـ collection
  Map<String, dynamic> toCreateJson() {
    return {
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'appointment_date':
          '${appointmentDate.year.toString().padLeft(4, '0')}-'
          '${appointmentDate.month.toString().padLeft(2, '0')}-'
          '${appointmentDate.day.toString().padLeft(2, '0')}',
      'appointment_time': appointmentTime,
      'type': type,
    };
  }

  static int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
  AppointmentStatus get effectiveStatus {
  if (status != AppointmentStatus.upcoming) return status;

  final appointmentDateTime = _combineDateAndTime(
    appointmentDate,
    appointmentTime,
  );

  if (appointmentDateTime.isBefore(DateTime.now())) {
    return AppointmentStatus.completed;
  }

  return status;
}

static DateTime _combineDateAndTime(DateTime date, String time) {
  // appointmentTime بالشكل "09:00" أو "09:30" ... إلخ
  final parts = time.split(':');
  final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
  final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
  return DateTime(date.year, date.month, date.day, hour, minute);
}
}
