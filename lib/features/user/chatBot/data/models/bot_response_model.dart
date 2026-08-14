class BotResponseModel {
  final String reply;
  final bool canBook;
  final int? doctorId;

  BotResponseModel({required this.reply, required this.canBook, this.doctorId});

  factory BotResponseModel.fromJson(Map<String, dynamic> json) {
    return BotResponseModel(
      // حماية النصوص والأنواع
      reply: json['reply']?.toString() ?? '',
      canBook: json['can_book'] is bool
          ? json['can_book']
          : (json['can_book'] == 1 || json['can_book'] == 'true'),
      doctorId: json['doctor_id'] is int
          ? json['doctor_id']
          : int.tryParse(json['doctor_id']?.toString() ?? ''),
    );
  }
}
