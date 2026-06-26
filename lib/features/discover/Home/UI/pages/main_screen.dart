import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/Home/UI/pages/home_screen.dart';

import 'package:medica_app/features/user/chatBot/UI/chatbot_screen.dart';
import 'package:medica_app/features/user/profile/UI/pages/profile_screen.dart';

// 💡 شاشات مؤقتة لحين بناء الشاشات الفعلية للمواعيد، الشات بوت، السجلات، والبروفايل
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title, style: const TextStyle(fontSize: 20))),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // قائمة الشاشات المرتبطة بالترتيب بالناف بار
  final List<Widget> _screens = [
    const HomeScreen(), // شاشتنا الرئيسية الجاهزة
    const PlaceholderScreen(title: "Appointments Screen"),
    const ChatBotScreen(),
    const PlaceholderScreen(title: "articals Screen"),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // تحديد نوع الناف بار ليكون ثابتاً ومريحاً في العرض ومطابق للفيجما
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark
              ? AppColors.darkcardBackground
              : AppColors.cardBackground,
          selectedItemColor: isDark ? AppColors.darkprimary : AppColors.primary,
          unselectedItemColor: isDark
              ? AppColors.darktextSecondary
              : AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: [
            // 1. الرئيسية
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.home_filled,
              ), // الأيقونة ممتلئة عند الاختيار
              label: "nav_bar.home".tr(),
            ),
            // 2. المواعيد
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today_rounded),
              label: "nav_bar.appointments".tr(),
            ),
            // 3. الشات بوت (تم استبدالها بأيقونة ذكاء اصطناعي/محادثة تفاعلية أنيقة وتناسب الهوية الطبية للفيجما)
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.smart_toy_outlined,
              ), // شكل روبوت ذكي رائع ومناسب جداً للشات بوت
              activeIcon: const Icon(Icons.smart_toy_rounded),
              label: "nav_bar.chatbot".tr(),
            ),
            // 4. السجلات/الروشتات
            BottomNavigationBarItem(
              icon: const Icon(Icons.description_outlined),
              activeIcon: const Icon(Icons.description_rounded),
              label: "nav_bar.articles".tr(),
            ),
            // 5. الحساب الشخصي
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: "nav_bar.profile".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
