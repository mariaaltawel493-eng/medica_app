import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/features/onboarding/onboarding_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // قائمة البيانات باستخدام مفاتيح الترجمة التي جهزناها
  late List<OnboardingModel> pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نملأ القائمة هنا للتأكد من أن الترجمة جاهزة
    pages = [
      OnboardingModel(
        image: "assets/animations/animation_onboarding.json.json",
        title: "onboarding.title1".tr(),
        description: "onboarding.desc1".tr(),
        isLottie: true,
      ),
      OnboardingModel(
        image: "assets/images/security.gif", // الصورة الثانية
        title: "onboarding.title2".tr(),
        description: "onboarding.desc2".tr(),
        isLottie: false,
      ),
      OnboardingModel(
        image: "assets/images/security.gif", // الصورة الثالثة
        title: "onboarding.title3".tr(),
        description: "onboarding.desc3".tr(),
        isLottie: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // زر التخطي (Skip)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    // الانتقال المباشر لآخر صفحة أو للـ Login
                    _pageController.jumpToPage(pages.length - 1);
                  },
                  child: Text(
                    "onboarding.skip".tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // عرض الأنميشن أو الصورة
                        pages[index].isLottie
                            ? Lottie.asset(
                                pages[index].image,
                                height: 300,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(pages[index].image, height: 300),
                        const SizedBox(height: 40),
                        Text(
                          pages[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pages[index].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // زر التنقل (التالي / ابدأ) باستخدام AppButton تبعك
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: AppButton(
                text: _currentPage == pages.length - 1
                    ? "onboarding.start".tr()
                    : "onboarding.next".tr(),
                onPressed: () {
                  if (_currentPage < pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // هون الكود لما يضغط "ابدأ الآن" بعد آخر شاشة
                    Navigator.pushNamed(context, '/login');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
