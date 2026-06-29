import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/articles/logic/articles_bloc/articles_bloc.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final int articleId;

  const ArticleDetailsScreen({super.key, required this.articleId});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesBloc>().add(
      FetchArticleDetailsEvent(widget.articleId),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      body: BlocConsumer<ArticlesBloc, ArticlesState>(
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

          if (state is ArticleDetailsLoaded) {
            final article = state.article;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDark
                                  ? AppColors.darktextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.bookmark_border,
                            color: isDark
                                ? AppColors.darktextPrimary
                                : AppColors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          article.featuredImageUrl ?? '',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkcardBackground
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.red,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            article.publishedAt,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darktextSecondary
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              article.category,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darktextPrimary
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: isDark
                            ? AppColors.darktextSecondary.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.content ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.7,
                          color: isDark
                              ? AppColors.darktextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
