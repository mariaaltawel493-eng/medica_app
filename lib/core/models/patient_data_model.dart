// FILE: lib/core/models/patient_data_model.dart
// نموذج بيانات المريض — محدَّث بـ factory empty() آمن ومتكامل

class PatientDataModel {
  final int id;
  final DateTime dateOfBirth;
  final String gender;
  final String? qrCodeUrl;
  final String? bloodType;
  final List<String>? chronicDiseases;
  final List<String>? allergies;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String? notes;
  final List<String>? currentMedications;
  final List<String>? pastSurgeries;
  final List<dynamic>? documents;

  const PatientDataModel({
    required this.id,
    required this.dateOfBirth,
    required this.gender,
    this.qrCodeUrl,
    this.bloodType,
    this.chronicDiseases,
    this.allergies,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.notes,
    this.currentMedications,
    this.pastSurgeries,
    this.documents,
  });

  // fromJson: تحويل JSON من الـ API إلى كائن

  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      id: _parseInt(json['id']),
      dateOfBirth: _parseDate(json['date_of_birth']),
      gender: json['gender']?.toString() ?? '',
      qrCodeUrl: json['qr_code_url']?.toString(),
      bloodType: json['blood_type']?.toString(),
      chronicDiseases: _parseStringList(json['chronic_diseases']),
      allergies: _parseStringList(json['allergies']),
      address: json['address']?.toString(),
      emergencyContactName: json['emergency_contact_name']?.toString(),
      emergencyContactPhone: json['emergency_contact_phone']?.toString(),
      emergencyContactRelation: json['emergency_contact_relation']?.toString(),
      notes: json['notes']?.toString(),
      currentMedications: _parseStringList(json['current_medications']),
      pastSurgeries: _parseStringList(json['past_surgeries']),
      documents: json['documents'] as List<dynamic>? ?? const [],
    );
  }

  // factory empty(): كائن افتراضي فارغ — الحل الجذري لمشكلة LateInitializationError
  // يُستخدم عندما يكون المريض جديداً ولا يملك ملفاً طبياً على السيرفر
  // مضمون عدم الـ null على الـ required fields

  factory PatientDataModel.empty() {
    return PatientDataModel(
      id: 0,
      dateOfBirth: DateTime.now(),
      gender: '',
      // جميع الحقول الاختيارية null بشكل صريح
      qrCodeUrl: null,
      bloodType: null,
      chronicDiseases: const [],
      allergies: const [],
      address: null,
      emergencyContactName: null,
      emergencyContactPhone: null,
      emergencyContactRelation: null,
      notes: null,
      currentMedications: const [],
      pastSurgeries: const [],
      documents: const [],
    );
  }

  // toJson: تحويل الكائن إلى JSON للإرسال في الـ API

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'qr_code_url': qrCodeUrl,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
      'address': address,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'emergency_contact_relation': emergencyContactRelation,
      'notes': notes,
      'current_medications': currentMedications,
      'past_surgeries': pastSurgeries,
    };
  }

  // copyWith: لإنشاء نسخة معدَّلة مع الحفاظ على القيم القديمة

  PatientDataModel copyWith({
    int? id,
    DateTime? dateOfBirth,
    String? gender,
    String? qrCodeUrl,
    String? bloodType,
    List<String>? chronicDiseases,
    List<String>? allergies,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? notes,
    List<String>? currentMedications,
    List<String>? pastSurgeries,
  }) {
    return PatientDataModel(
      id: id ?? this.id,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      bloodType: bloodType ?? this.bloodType,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      allergies: allergies ?? this.allergies,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      notes: notes ?? this.notes,
      currentMedications: currentMedications ?? this.currentMedications,
      pastSurgeries: pastSurgeries ?? this.pastSurgeries,
    );
  }

  bool get isProfileComplete {
    // نعتبر الملف غير مكتمل إذا كانت أي من هذه الحقول فارغة
    return (bloodType != null && bloodType!.isNotEmpty) &&
        (address != null && address!.isNotEmpty) &&
        (emergencyContactName != null && emergencyContactName!.isNotEmpty) &&
        (emergencyContactPhone != null && emergencyContactPhone!.isNotEmpty);
  }
  // PRIVATE HELPERS: تحليل آمن للـ JSON

  /// تحويل آمن لقيمة int — يرجع 0 في حال null أو نوع خاطئ
  static int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  /// تحليل آمن للتاريخ — يرجع DateTime.now() في حال null أو تنسيق خاطئ
  static DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  /// تحليل آمن لمصفوفة strings — يرجع null في حال null وقائمة في حال وجود بيانات
  static List<String>? _parseStringList(dynamic val) {
    if (val == null) return null;
    if (val is List) {
      return val.map((e) => e.toString()).toList();
    }
    return null;
  }
}
