part of 'articles_bloc.dart';

@immutable
sealed class ArticlesEvent {}

/// جلب كل المقالات (للـ AllArticlesScreen)
class FetchArticlesEvent extends ArticlesEvent {}

/// جلب أكثر المقالات مشاهدةً (للـ Trending section)
class FetchTopArticlesEvent extends ArticlesEvent {}

/// جلب مقالات تبعاً لفئة محددة
class FetchArticlesByCategoryEvent extends ArticlesEvent {
  final int categoryId;
  FetchArticlesByCategoryEvent(this.categoryId);
}

/// جلب تفاصيل مقال واحد
class FetchArticleDetailsEvent extends ArticlesEvent {
  final int articleId;
  FetchArticleDetailsEvent(this.articleId);
}

/// بحث في المقالات
class SearchArticlesEvent extends ArticlesEvent {
  final String keyword;
  SearchArticlesEvent(this.keyword);
}
