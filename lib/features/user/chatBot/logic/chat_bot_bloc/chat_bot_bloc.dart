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
      // نمرر القائمة الحالية (الفارغة في البداية) لحالة اللودنج
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
      // أخذ نسخة من الرسائل الحالية وإضافة رسالة المستخدم لها فوراً لتعرض بالـ UI بدون أي تأخير
      final updatedMessages = List<ChatMessageModel>.from(state.messages)
        ..add(ChatMessageModel(role: 'user', content: event.message));

      // ننتقل لحالة التحميل ومعنا القائمة المحدثة لتبقى الشاشة ثابتة ومستقرة
      emit(ChatBotLoading(updatedMessages));

      try {
        // استدعاء السيرفر وانتظار الرد التفاعلي
        final response = await chatBotRepo.sendMessage(event.message);
        bool shouldShowButton =
            response.reply.contains("الدكتور") ||
            response.reply.contains("طبيب") ||
            response.reply.contains('doctor');
        // إضافة رد البوت النظيف إلى القائمة المحدثة
        updatedMessages.add(
          ChatMessageModel(
            role: 'assistant',
            content: response.reply,
            canBook: shouldShowButton,
            doctorId: null,
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
        // حماية هندسية: لو السيرفر ضرب 503 أو فصل، بنطلع حالة الخطأ بس بنحافظ على رسائل الشاشة تماماً بدون اختفاء!
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
