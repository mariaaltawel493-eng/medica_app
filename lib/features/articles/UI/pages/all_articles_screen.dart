import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/articles/UI/pages/article_search_delegate.dart';
import 'package:medica_app/features/articles/UI/widgets/article-item.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';

class AllArticlesScreen extends StatefulWidget {
  const AllArticlesScreen({super.key});

  @override
  State<AllArticlesScreen> createState() => _AllArticlesScreenState();
}

class _AllArticlesScreenState extends State<AllArticlesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesBloc>().add(FetchArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
        ),
        title: Text(
          'articles.title'.tr(),
          style: TextStyle(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ArticleSearchDelegate());
            },
            icon: Icon(
              Icons.search,
              color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
          },
          builder: (context, state) {
            if (state is ArticlesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ArticlesListLoaded) {
              if (state.articles.isEmpty) {
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
                padding: const EdgeInsets.only(top: 20),
                itemCount: state.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return ArticleItem(
                    articleId: article.id,
                    image: article.featuredImageUrl ?? '',
                    title: article.title,
                    date: article.publishedAt,
                    category: article.category,
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
