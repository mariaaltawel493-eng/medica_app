class NotificationResponseModel {
  final List<NotificationModel> data;
  final PaginationModel pagination;

  NotificationResponseModel({required this.data, required this.pagination});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      data: (json['data'] as List? ?? [])
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>?
  data; // البيانات الإضافية المرسلة مع الإشعار (مثل id الدواء أو الحجز)
  final bool isRead;
  final String? sentAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.isRead,
    this.sentAt,
  });

  // يحول بيانات الإشعار المفرد من JSON إلى Object
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',

      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
      isRead: json['is_read'] ?? false,
      sentAt: json['sent_at'],
    );
  }
}

/// هذا الكلاس يمثل معلومات الـ Pagination المعتمدة على الـ Cursor (last_id)
class PaginationModel {
  final bool hasMore;
  final int?
  nextLastId; // الـ ID الخاص بآخر إشعار ل نرسله في الطلب القادم ل جلب الإشعارات الأقدم

  PaginationModel({required this.hasMore, this.nextLastId});

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      hasMore: json['has_more'] ?? false,
      nextLastId: json['next_last_id'],
    );
  }
}
