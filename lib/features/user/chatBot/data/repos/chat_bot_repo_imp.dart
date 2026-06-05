import 'package:medica_app/core/networking/api_service.dart';
import '../models/chat_message_model.dart';
import '../models/bot_response_model.dart';
import 'chat_bot_repo.dart';

class ChatBotRepoImp implements ChatBotRepo {
  final ApiService apiService;

  ChatBotRepoImp(this.apiService);

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    try {
      // استدعاء راوت الـ GET من السيرفر
      final response = await apiService.get("chat/history");
      final rawData = response['data'];

      List dataList = [];

      // حماية ذكية: فحص هل الباك إيند باعث الـ data كـ Map أو كـ List حقيقية
      if (rawData is Map) {
        dataList = rawData.values.toList();
      } else if (rawData is List) {
        dataList = rawData;
      }

      // تمرير القائمة النظيفة والمضمونة للموديل
      return dataList.map((json) => ChatMessageModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BotResponseModel> sendMessage(String message) async {
    try {
      // إرسال الرسالة للباك إيند بحقل 'message' متل ما الكونترولر ناطر بالظبط
      final response = await apiService.post('chat', {'message': message});

      // تمرير كائن الـ data لـ BotResponseModel
      return BotResponseModel.fromJson(response['data'] ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> clearChat() async {
    try {
      // استدعاء راوت الـ DELETE لمسح البيانات بقاعدة البيانات
      final response = await apiService.delete('chat/history');
      return response['message'] ?? "Chat history cleared";
    } catch (e) {
      rethrow;
    }
  }
}
