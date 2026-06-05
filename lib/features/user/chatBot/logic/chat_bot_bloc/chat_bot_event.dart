part of 'chat_bot_bloc.dart';

@immutable
abstract class ChatBotEvent {}

class FetchChatHistoryEvent extends ChatBotEvent {}

class SendMessageEvent extends ChatBotEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ClearChatHistoryEvent extends ChatBotEvent {}
