class MedicationReminderResponseModel {
  final List<MedicationReminderModel> data;
  final MedicationPaginationModel pagination;

  MedicationReminderResponseModel({
    required this.data,
    required this.pagination,
  });

  factory MedicationReminderResponseModel.fromJson(Map<String, dynamic> json) {
    return MedicationReminderResponseModel(
      data: (json['data'] as List? ?? [])
          .map((e) => MedicationReminderModel.fromJson(e))
          .toList(),
      pagination: MedicationPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MedicationReminderModel {
  final int id;
  final String medicationName;
  final String? dosage;
  final String frequency;
  final List<String> reminderTimes; // مصفوفة الساعات القادمة من الباكيند
  final String startDate;
  final String? endDate;
  final bool isActive;
  final String? notes;

  MedicationReminderModel({
    required this.id,
    required this.medicationName,
    this.dosage,
    required this.frequency,
    required this.reminderTimes,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.notes,
  });

  factory MedicationReminderModel.fromJson(Map<String, dynamic> json) {
    return MedicationReminderModel(
      id: json['id'] ?? 0,
      medicationName: json['medication_name'] ?? '',
      dosage: json['dosage'],
      frequency: json['frequency'] ?? 'daily',
      reminderTimes: (json['reminder_times'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      isActive: json['is_active'] ?? false,
      notes: json['notes'],
    );
  }
}

class MedicationPaginationModel {
  final bool hasMore;
  final int? nextLastId;

  MedicationPaginationModel({required this.hasMore, this.nextLastId});

  factory MedicationPaginationModel.fromJson(Map<String, dynamic> json) {
    return MedicationPaginationModel(
      hasMore: json['has_more'] ?? false,
      nextLastId: json['next_last_id'],
    );
  }
}
