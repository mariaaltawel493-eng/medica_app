part of 'chat_bot_bloc.dart';

@immutable
abstract class ChatBotState {
  // جعلنا قائمة الرسائل جزء أساسي ومثبت في الـ State الأساسي
  final List<ChatMessageModel> messages;
  const ChatBotState({this.messages = const []});
}

// 1. الحالة الابتدائية عند فتح الشاشة (القائمة فاضية)
class ChatBotInitial extends ChatBotState {
  const ChatBotInitial() : super(messages: const []);
}

// 2. حالة التحميل (نمرر لها القائمة الحالية لتظل معروضة بالشاشة أثناء انتظار السيرفر)
class ChatBotLoading extends ChatBotState {
  const ChatBotLoading(List<ChatMessageModel> currentMessages)
    : super(messages: currentMessages);
}

// 3. حالة نجاح جلب الأرشيف من السيرفر
class ChatHistorySuccess extends ChatBotState {
  const ChatHistorySuccess(List<ChatMessageModel> messages)
    : super(messages: messages);
}

// 4. حالة نجاح إرسال رسالة واستقبال رد البوت (شايلة القائمة المحدثة بالرد)
class ChatMessageSendSuccess extends ChatBotState {
  final String reply;
  final bool canBook;
  final int? doctorId;

  const ChatMessageSendSuccess({
    required List<ChatMessageModel> messages,
    required this.reply,
    required this.canBook,
    this.doctorId,
  }) : super(messages: messages);
}

// 5. حالة نجاح مسح المحادثة بالكامل (تعود القائمة فارغة)
class ChatClearSuccess extends ChatBotState {
  final String message;
  const ChatClearSuccess(this.message) : super(messages: const []);
}

// 6. حالة الفشل (نمرر لها القائمة الحالية لتبقى الرسائل ثابتة بالشاشة ويظهر فقط السناك بار بالخطأ)
class ChatBotError extends ChatBotState {
  final String message;
  const ChatBotError(this.message, List<ChatMessageModel> currentMessages)
    : super(messages: currentMessages);
}
