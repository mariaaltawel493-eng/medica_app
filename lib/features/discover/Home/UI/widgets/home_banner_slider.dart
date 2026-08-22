import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/articles/UI/pages/article_details_screen.dart';
import 'package:medica_app/features/articles/data/repos/articles_repo.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';
import 'package:medica_app/features/discover/Home/data/models/banner_model.dart';
// import 'package:get_it/get_it.dart'; // قم بإلغاء التعليق إذا كنت تستخدم getIt

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
              final bool isAdvertisement = banner.type == 'advertisement';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(
                  horizontal: isAdvertisement ? 0 : 16,
                  vertical: isAdvertisement ? 0 : 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkprimary : AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: isAdvertisement
                    ? SizedBox.expand(
                        child:
                            isServerDataAvailable &&
                                banner.image != null &&
                                banner.image!.isNotEmpty
                            ? Image.network(banner.image!, fit: BoxFit.cover)
                            : Image.asset(
                                banner.image ??
                                    'assets/images/banner_welcome.png',
                                fit: BoxFit.cover,
                              ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
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
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          // نقوم بإنشاء الـ Bloc وتمرير الـ Repo من GetIt
                                          create: (_) =>
                                              ArticlesBloc(
                                                GetIt.I<ArticlesRepo>(),
                                              )..add(
                                                FetchArticleDetailsEvent(
                                                  banner.id,
                                                ),
                                              ), // نقوم بجلب البيانات فوراً
                                          child: ArticleDetailsScreen(
                                            articleId: banner.id,
                                          ),
                                        ),
                                      ),
                                    );
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
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 120,
                              alignment: Alignment.center,
                              child:
                                  isServerDataAvailable &&
                                      banner.image != null &&
                                      banner.image!.isNotEmpty
                                  ? Image.network(
                                      banner.image!,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset(
                                      banner.image ??
                                          'assets/images/banner_welcome.png',
                                      height: 110,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            activeBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? (isDark ? AppColors.darkprimary : AppColors.primary)
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
