import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/Home/data/models/banner_model.dart';

class HomeBannerSlider extends StatefulWidget {
  final List<BannerModel>? banners;

  const HomeBannerSlider({super.key, this.banners});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // البانرات الترحيبية الثابتة للمستخدم الجديد مترجمة بالكامل
    final List<BannerModel> firstTimeBanners = [
      BannerModel(
        type: 'advertisement',
        id: -1,
        title: "home.welcome_title".tr(),
        image: 'assets/images/lets_you_in-removebg.png',
      ),
      BannerModel(
        type: 'article',
        id: -2,
        title: "home.qr_title".tr(),
        category: 'Features',
        image: 'assets/images/qr_code-removebg-preview.png',
      ),
      BannerModel(
        type: 'article',
        id: -3,
        title: "home.articles_title".tr(),
        category: 'Health',
        image: 'assets/images/my_appointment_upcoming_empty.png',
      ),
    ];

    // تحديد القائمة النشطة (إما من السيرفر أو الافتراضية)
    final bool isServerDataAvailable =
        widget.banners != null && widget.banners!.isNotEmpty;
    final List<BannerModel> activeBanners = isServerDataAvailable
        ? widget.banners!
        : firstTimeBanners;

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: activeBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = activeBanners[index];
              final bool isArticle = banner.type == 'article';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkprimary : AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // توسيط النص والصورة عمودياً بالكامل
                  children: [
                    // 1. قسم النصوص والزر
                    Expanded(
                      flex: 4, // يمنح النص مساحة مريحة ومناسبة للقراءة
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner.title ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          if (isArticle) ...[
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                // الانتقال لشاشة المقالات لاحقاً
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "home.read_more".tr(),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkprimary
                                        : AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 2. قسم الصورة المكبّر والموسط عمودياً وأفقياً
                    Expanded(
                      flex: 4, // تكبير مساحة عرض قسم الصورة
                      child: Container(
                        height:
                            120, // رفع الارتفاع الإجمالي لملء الكارد وتكبير الصورة
                        alignment:
                            Alignment.center, // التثبيت في المنتصف تماماً
                        child:
                            isServerDataAvailable &&
                                banner.image != null &&
                                banner.image!.isNotEmpty
                            ? Image.network(banner.image!, fit: BoxFit.contain)
                            : Image.asset(
                                banner.image ??
                                    'assets/images/banner_welcome.png',
                                height: 110, // تكبير حجم الـ Asset Image مباشرة
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // 3. نقاط التحكم السفلية الدائرية الثابتة (Indicator Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            activeBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 7,
              width: 7, // تثبيت العرض مساوي للارتفاع لتظل نقطة دائرية ولا تتمدد
              decoration: BoxDecoration(
                shape: BoxShape.circle, // تحويل النقاط إلى دوائر رسمية
                color: _currentIndex == index
                    ? (isDark
                          ? AppColors.darkprimary
                          : AppColors.primary) // لون أزرق عند الاختيار
                    : (isDark
                          ? Colors.grey[700]
                          : Colors.grey[300]), // لون رمادي عند عدم الاختيار
              ),
            ),
          ),
        ),
      ],
    );
  }
}
