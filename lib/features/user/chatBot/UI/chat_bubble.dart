import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import '../data/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isDark;

  const ChatBubble({super.key, required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: message.content));
        if (context.mounted) {
          Appsnackbar.showSuccess(context, 'chatbot.copied_to_clipboard'.tr());
        }
      },
      child: Align(
        alignment: message.isUser
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // فقاعة النص
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkcardBackground
                          : Colors.grey.withOpacity(0.08)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 0),
                  bottomRight: Radius.circular(message.isUser ? 0 : 20),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black87),
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),

            // زر الحجز - يظهر فقط إذا كانت الرسالة من البوت وكانت canBook تساوي true
            /*  if (!message.isUser &&
                (message.canBook == true || message.content.contains('دكتور')))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    // هنا يتم تمرير الـ doctorId الذي يأتي من الموديل
                    print("الانتقال لصفحة الحجز للطبيب رقم: ");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(doctorId: message.doctorId!)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "احجز الآن".tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
