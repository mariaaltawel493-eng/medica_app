import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repos/chat_bot_repo.dart';

part 'chat_bot_event.dart';
part 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChatBotRepo chatBotRepo;

  ChatBotBloc(this.chatBotRepo) : super(const ChatBotInitial()) {
    // 1. حدث جلب أرشيف المحادثة (GET)
    on<FetchChatHistoryEvent>((event, emit) async {
      emit(ChatBotLoading(state.messages));
      try {
        final messages = await chatBotRepo.getChatHistory();
        emit(ChatHistorySuccess(messages));
      } catch (e) {
        emit(ChatBotError(e.toString(), state.messages));
      }
    });

    // 2. حدث إرسال رسالة جديدة للبوت وانتظار الرد (POST)
    on<SendMessageEvent>((event, emit) async {
      // أخذ نسخة من الرسائل الحالية وإضافة رسالة المستخدم لها فوراً
      final updatedMessages = List<ChatMessageModel>.from(state.messages)
        ..add(ChatMessageModel(role: 'user', content: event.message));

      emit(ChatBotLoading(updatedMessages));

      try {
        // استدعاء السيرفر وانتظار الرد التفاعلي
        final response = await chatBotRepo.sendMessage(event.message);

        // إضافة رد البوت إلى القائمة المحدثة مع الاعتماد حصرياً على بيانات الـ Backend
        updatedMessages.add(
          ChatMessageModel(
            role: 'assistant',
            content: response.reply,
            canBook: response.canBook,
            doctorId: response.doctorId,
          ),
        );

        emit(
          ChatMessageSendSuccess(
            messages: updatedMessages,
            reply: response.reply,
            canBook: response.canBook,
            doctorId: response.doctorId,
          ),
        );
      } catch (e) {
        emit(
          ChatBotError(
            "Connection timed out, please try again",
            updatedMessages,
          ),
        );
      }
    });

    // 3. حدث مسح تاريخ المحادثة بالكامل (DELETE)
    on<ClearChatHistoryEvent>((event, emit) async {
      emit(ChatBotLoading(state.messages));
      try {
        final successMessage = await chatBotRepo.clearChat();
        emit(ChatClearSuccess(successMessage));
      } catch (e) {
        emit(ChatBotError(e.toString(), state.messages));
      }
    });
  }
}
