class MonitoringReminderResponseModel {
  final List<MonitoringReminderModel> data;
  final MonitoringPaginationModel pagination;

  MonitoringReminderResponseModel({
    required this.data,
    required this.pagination,
  });

  factory MonitoringReminderResponseModel.fromJson(Map<String, dynamic> json) {
    return MonitoringReminderResponseModel(
      data: (json['data'] as List? ?? [])
          .map((e) => MonitoringReminderModel.fromJson(e))
          .toList(),
      pagination: MonitoringPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MonitoringReminderModel {
  final int id;
  final String trackerName; // اسم المؤشر (مثال: قياس السكر، الضغط)
  final String reminderTime; // وقت التذكير اليومي
  final String planName; // اسم الخطة العلاجية المرتبطة
  final String? diagnosis; // التشخيص
  final bool isActive;

  MonitoringReminderModel({
    required this.id,
    required this.trackerName,
    required this.reminderTime,
    required this.planName,
    this.diagnosis,
    required this.isActive,
  });

  factory MonitoringReminderModel.fromJson(Map<String, dynamic> json) {
    return MonitoringReminderModel(
      id: json['id'] ?? 0,
      trackerName: json['tracker_name'] ?? '',
      reminderTime: json['reminder_time'] ?? '',
      planName: json['plan_name'] ?? '',
      diagnosis: json['diagnosis'],
      isActive: json['is_active'] ?? false,
    );
  }
}

class MonitoringPaginationModel {
  final bool hasMore;
  final int? nextLastId;

  MonitoringPaginationModel({required this.hasMore, this.nextLastId});

  factory MonitoringPaginationModel.fromJson(Map<String, dynamic> json) {
    return MonitoringPaginationModel(
      hasMore: json['has_more'] ?? false,
      nextLastId: json['next_last_id'],
    );
  }
}
