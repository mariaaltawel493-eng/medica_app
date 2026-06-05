class ChatMessageModel {
  final int? id;
  final String role;
  final String content;
  final bool? canBook;
  final int? doctorId;

  ChatMessageModel({
    this.id,
    required this.role,
    required this.content,
    this.canBook,
    this.doctorId,
  });

  bool get isUser => role == 'user';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      role: json['role']?.toString() ?? 'user',
      content: json['content']?.toString() ?? '',
      canBook: json['can_book'],
      doctorId: json['doctor_id'] != null
          ? int.tryParse(json['doctor_id'].toString())
          : null,
    );
  }
}
