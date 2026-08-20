import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/articles/UI/pages/all_articles_screen.dart';
import 'package:medica_app/features/articles/UI/pages/article_details_screen.dart';
import 'package:medica_app/features/articles/UI/pages/article_search_delegate.dart';
import 'package:medica_app/features/articles/UI/widgets/article-item.dart';
import 'package:medica_app/features/articles/UI/widgets/category_chip.dart';
import 'package:medica_app/features/articles/UI/widgets/trending_article_card.dart';
import 'package:medica_app/features/articles/data/models/article_model.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String selectedCategory = 'newest';

  // نحتفظ بالبيانات محلياً لأن BLoC يُصدر state واحد في كل مرة
  List<ArticleModel> _topArticles = [];
  List<ArticleModel> _articles = [];

  @override
  void initState() {
    super.initState();
    // جلب المقالات الأكثر مشاهدةً أولاً
    context.read<ArticlesBloc>().add(FetchTopArticlesEvent());
    // ثم جلب مقالات الفئة الافتراضية
    Future.microtask(() {
      if (mounted) {
        context.read<ArticlesBloc>().add(FetchArticlesByCategoryEvent(1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ArticlesBloc, ArticlesState>(
          listener: (context, state) {
            if (state is ArticlesError) {
              String errorKey;
              if (state.message.contains('Network') ||
                  state.message.contains('connection')) {
                errorKey = 'errors.no_internet';
              } else {
                errorKey = 'errors.unknown';
              }
              Appsnackbar.showError(context, errorKey.tr());
            }
            // نحدّث البيانات المحلية عند وصول كل state جديد
            if (state is ArticlesTopLoaded) {
              setState(() {
                _topArticles = state.topArticles;
              });
            }
            if (state is ArticlesListLoaded) {
              setState(() {
                _articles = state.articles;
              });
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ─── HEADER ────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'articles.title'.tr(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: ArticleSearchDelegate(),
                              );
                            },
                            icon: Icon(
                              Icons.search,
                              color: isDark
                                  ? AppColors.darktextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark_border,
                              color: isDark
                                  ? AppColors.darktextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ─── TRENDING TITLE ────────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'articles.trending'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darktextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ─── TRENDING LIST ─────────────────────────────────────
                  SizedBox(
                    height: 220,
                    child: state is ArticlesLoading && _topArticles.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Builder(
                            builder: (context) {
                              final sorted = List.of(_topArticles)
                                ..sort(
                                  (a, b) => b.viewCount.compareTo(a.viewCount),
                                );
                              final trending = sorted.take(5).toList();

                              if (trending.isEmpty) {
                                return const SizedBox();
                              }

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: trending.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 15),
                                itemBuilder: (context, index) {
                                  final article = trending[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) =>
                                                GetIt.I<ArticlesBloc>(),
                                            child: ArticleDetailsScreen(
                                              articleId: article.id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: TrendingArticleCard(
                                      image: article.featuredImageUrl ?? '',
                                      articleId: article.id,
                                      title: article.title,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  // ─── ARTICLES TITLE + SEE ALL ──────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'articles.title'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => GetIt.I<ArticlesBloc>(),
                                child: const AllArticlesScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'articles.see_all'.tr(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ─── CATEGORY CHIPS ────────────────────────────────────
                  SizedBox(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryChip(
                          title: 'articles.newest'.tr(),
                          selected: selectedCategory == 'newest',
                          onTap: () {
                            setState(() => selectedCategory = 'newest');
                            context.read<ArticlesBloc>().add(
                                  FetchArticlesByCategoryEvent(1),
                                );
                          },
                        ),
                        const SizedBox(width: 10),
                        CategoryChip(
                          title: 'articles.health'.tr(),
                          selected: selectedCategory == 'Health',
                          onTap: () {
                            setState(() => selectedCategory = 'Health');
                            context.read<ArticlesBloc>().add(
                                  FetchArticlesByCategoryEvent(2),
                                );
                          },
                        ),
                        const SizedBox(width: 10),
                        CategoryChip(
                          title: 'articles.covid'.tr(),
                          selected: selectedCategory == 'Covid-19',
                          onTap: () {
                            setState(() => selectedCategory = 'Covid-19');
                            context.read<ArticlesBloc>().add(
                                  FetchArticlesByCategoryEvent(3),
                                );
                          },
                        ),
                        const SizedBox(width: 10),
                        CategoryChip(
                          title: 'articles.lifestyle'.tr(),
                          selected: selectedCategory == 'Lifestyle',
                          onTap: () {
                            setState(() => selectedCategory = 'Lifestyle');
                            context.read<ArticlesBloc>().add(
                                  FetchArticlesByCategoryEvent(4),
                                );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── ARTICLES LIST ─────────────────────────────────────
                  Expanded(
                    child: state is ArticlesLoading && _articles.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Builder(
                            builder: (context) {
                              if (_articles.isEmpty) {
                                return Center(
                                  child: Text(
                                    'articles.no_articles'.tr(),
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darktextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                itemCount: _articles.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 15),
                                itemBuilder: (context, index) {
                                  final article = _articles[index];
                                  return ArticleItem(
                                    articleId: article.id,
                                    image: article.featuredImageUrl ?? '',
                                    title: article.title,
                                    date: article.publishedAt,
                                    category: article.category,
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
