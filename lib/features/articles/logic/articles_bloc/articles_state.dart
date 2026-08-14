part of 'articles_bloc.dart';

@immutable
sealed class ArticlesState {}

class ArticlesInitial extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

/// نجاح جلب قائمة مقالات (articles أو topArticles أو نتائج بحث)
class ArticlesListLoaded extends ArticlesState {
  final List<ArticleModel> articles;
  ArticlesListLoaded(this.articles);
}

/// نجاح جلب مقالات Trending (الأكثر مشاهدة)
class ArticlesTopLoaded extends ArticlesState {
  final List<ArticleModel> topArticles;
  ArticlesTopLoaded(this.topArticles);
}

/// نجاح جلب تفاصيل مقال واحد
class ArticleDetailsLoaded extends ArticlesState {
  final ArticleModel article;
  ArticleDetailsLoaded(this.article);
}

class ArticlesError extends ArticlesState {
  final String message;
  ArticlesError(this.message);
}
