import 'package:medica_app/features/articles/data/models/article_model.dart';

abstract class ArticlesRepo {
  Future<List<ArticleModel>> getArticles();
  Future<List<ArticleModel>> getTopArticles();
  Future<List<ArticleModel>> getArticlesByCategory(int categoryId);
  Future<ArticleModel> getArticleDetails(int articleId);
  Future<List<ArticleModel>> searchArticles(String keyword);
}
