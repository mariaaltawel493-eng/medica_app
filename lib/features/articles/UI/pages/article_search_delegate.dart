import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/articles/UI/widgets/article-item.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';

class ArticleSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          'articles.search_hint'.tr(),
          style: TextStyle(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
      );
    }

    context.read<ArticlesBloc>().add(SearchArticlesEvent(query));

    return BlocConsumer<ArticlesBloc, ArticlesState>(
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ArticleItem(
                  articleId: article.id,
                  image: article.featuredImageUrl ?? '',
                  date: article.publishedAt,
                  title: article.title,
                  category: article.category,
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Text(
        'articles.search_hint'.tr(),
        style: TextStyle(
          color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
