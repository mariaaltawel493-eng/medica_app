import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/articles/data/models/article_model.dart';
import 'package:medica_app/features/articles/data/repos/articles_repo.dart';

class ArticlesRepoImp implements ArticlesRepo {
  final ApiService apiService;
  ArticlesRepoImp(this.apiService);

  @override
  Future<List<ArticleModel>> getArticles() async {
    try {
      final response = await apiService.get('articles');
      final List data = response['data'];
      return data.map((e) => ArticleModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ArticleModel>> getTopArticles() async {
    try {
      final response = await apiService.get('articles?limit=2');
      final List data = response['data'];
      return data.map((e) => ArticleModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(int categoryId) async {
    try {
      final response = await apiService.get('articles?category_id=$categoryId');
      final List data = response['data'];
      return data.map((e) => ArticleModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ArticleModel> getArticleDetails(int articleId) async {
    try {
      final response = await apiService.get('articles/$articleId');
      return ArticleModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(String keyword) async {
    try {
      final response = await apiService.get('articles?search=$keyword');
      final List data = response['data'];
      return data.map((e) => ArticleModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
