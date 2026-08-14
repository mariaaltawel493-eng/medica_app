import 'package:bloc/bloc.dart';
import 'package:medica_app/features/articles/data/models/article_model.dart';
import 'package:medica_app/features/articles/data/repos/articles_repo.dart';
import 'package:meta/meta.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesRepo articlesRepo;

  ArticlesBloc(this.articlesRepo) : super(ArticlesInitial()) {
    on<FetchArticlesEvent>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final articles = await articlesRepo.getArticles();
        emit(ArticlesListLoaded(articles));
      } catch (e) {
        emit(ArticlesError(e.toString()));
      }
    });

    on<FetchTopArticlesEvent>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final topArticles = await articlesRepo.getTopArticles();
        emit(ArticlesTopLoaded(topArticles));
      } catch (e) {
        emit(ArticlesError(e.toString()));
      }
    });

    on<FetchArticlesByCategoryEvent>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final articles = await articlesRepo.getArticlesByCategory(
          event.categoryId,
        );
        emit(ArticlesListLoaded(articles));
      } catch (e) {
        emit(ArticlesError(e.toString()));
      }
    });

    on<FetchArticleDetailsEvent>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final article = await articlesRepo.getArticleDetails(event.articleId);
        emit(ArticleDetailsLoaded(article));
      } catch (e) {
        emit(ArticlesError(e.toString()));
      }
    });

    on<SearchArticlesEvent>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final articles = await articlesRepo.searchArticles(event.keyword);
        emit(ArticlesListLoaded(articles));
      } catch (e) {
        emit(ArticlesError(e.toString()));
      }
    });
  }
}
