import '../models/chat_message_model.dart';
import '../models/bot_response_model.dart';

abstract class ChatBotRepo {
  // 1. جلب تاريخ المحادثة
  Future<List<ChatMessageModel>> getChatHistory();

  // 2. إرسال رسالة جديدة واستقبال رد البوت التفاعلي
  Future<BotResponseModel> sendMessage(String message);

  // 3. مسح المحادثة بالكامل
  Future<String> clearChat();
}
