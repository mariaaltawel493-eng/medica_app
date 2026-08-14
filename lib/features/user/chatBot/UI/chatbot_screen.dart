import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../logic/chat_bot_bloc/chat_bot_bloc.dart';
import '../data/models/chat_message_model.dart';
import 'chat_bubble.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speech = SpeechToText();
  bool _isWriting = false;
  bool _islistening = false;

  @override
  void initState() {
    super.initState();
    _intitSpeech();

    _messageController.addListener(() {
      if (_messageController.text.trim().isNotEmpty != _isWriting) {
        if (mounted) {
          setState(() {
            _isWriting = _messageController.text.trim().isNotEmpty;
          });
        }
      }
    });
  }

  void _intitSpeech() async {
    await _speech.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  // --- التعديل هنا في دالة _listen ---
  void _listen() async {
    // الحصول على لغة التطبيق الحالية (ar أو en)
    String currentLanguage = context.locale.languageCode;

    if (!_islistening) {
      bool available = await _speech.initialize();
      if (available) {
        if (mounted) {
          setState(() => _islistening = true);
        }
        _speech.listen(
          // ضبط اللغة ديناميكياً حسب لغة التطبيق
          localeId: currentLanguage == 'ar' ? 'ar_SA' : 'en_US',
          // وضع التأكيد لتقليل الأخطاء في فهم الكلام
          listenMode: ListenMode.confirmation,
          onResult: (val) {
            if (mounted) {
              setState(() {
                _messageController.text = val.recognizedWords;
                _isWriting = _messageController.text.trim().isNotEmpty;
              });
            }
          },
        );
      }
    } else {
      if (mounted) {
        setState(() => _islistening = false);
      }
      _speech.stop();
    }
  }
  // ------------------------------------

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext blocContext) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'chatbot.delete_title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('chatbot.delete_confirm_msg'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'chatbot.cancel'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              blocContext.read<ChatBotBloc>().add(ClearChatHistoryEvent());
            },
            child: Text(
              'chatbot.delete'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => getIt<ChatBotBloc>()..add(FetchChatHistoryEvent()),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'chatbot.title'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            BlocBuilder<ChatBotBloc, ChatBotState>(
              builder: (blocContext, state) {
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmationDialog(blocContext),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<ChatBotBloc, ChatBotState>(
          listener: (context, state) {
            if (state is ChatBotError) {
              print("chatbot error from server:${state.message}");
              String errorKey = "errors.something_wrong";
              if (state.message.contains('SoketException') ||
                  state.message.contains('connection')) {
                errorKey = "errors.no_internet";
              } else if (state.message.contains('401') ||
                  state.message.contains('unauthorized')) {
                errorKey = 'errors.unauthorized';
              }
              Appsnackbar.showError(context, errorKey.tr());
            }
            if (state is ChatHistorySuccess ||
                state is ChatMessageSendSuccess ||
                state is ChatBotLoading) {
              _scrollToBottom();
            }
            if (state is ChatClearSuccess) {
              Appsnackbar.showSuccess(context, state.message.tr());
            }
          },
          builder: (context, state) {
            final List<ChatMessageModel> messagesList = state.messages;

            if (messagesList.isEmpty && state is ChatBotLoading) {
              return AppLoadingIndicator();
            }

            return Column(
              children: [
                Expanded(
                  child: messagesList.isEmpty
                      ? Center(
                          child: Text(
                            'chatbot.no_messages'.tr(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount:
                              messagesList.length +
                              (state is ChatBotLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == messagesList.length) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkcardBackground
                                        : Colors.grey.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final message = messagesList[index];
                            return ChatBubble(message: message, isDark: isDark);
                          },
                        ),
                ),
                _buildInputArea(isDark, context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputArea(
    bool isDark,
    BuildContext blocContext,
    ChatBotState state,
  ) {
    final bool isLoading = state is ChatBotLoading;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkcardBackground
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !isLoading,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'chatbot.hint_text'.tr(),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_islistening) {
                _listen();
              } else if (_isWriting && !isLoading) {
                final text = _messageController.text.trim();
                blocContext.read<ChatBotBloc>().add(SendMessageEvent(text));
                _messageController.clear();
                if (mounted) {
                  setState(() => _isWriting = false);
                }
                _scrollToBottom();
              } else if (!isLoading) {
                _listen();
              }
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: isLoading ? Colors.grey : AppColors.primary,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _islistening
                      ? Icons.mic_off
                      : (_isWriting ? Icons.send_rounded : Icons.mic),
                  key: ValueKey<String>(
                    _islistening
                        ? 'listening'
                        : (_isWriting ? 'writing' : 'idle'),
                  ),
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
