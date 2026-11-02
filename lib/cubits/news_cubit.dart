import 'package:bloc/bloc.dart';
import 'package:news_cubit_2/models/news_model.dart';

import '../services/news_service.dart';
import 'news_state.dart';


class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  int _latestSearchNumber = 0;
  final Map<String, NewsModel> _categoryCache = {};

  void invalidateSearch() {
    _latestSearchNumber++;
  }

  void clearSearch() {
    invalidateSearch();
    emit(SearchInitial());
  }

  Future<void> getArticles({required String category}) async {
    final normalizedCategory = category.toLowerCase();

    final cachedModel = _categoryCache[normalizedCategory];
    if (cachedModel != null) {
      emit(NewsLoaded(model: cachedModel));
      return;
    }

    emit(NewsLoading());

    try {
      final model = await NewsService.getNews(
        category: normalizedCategory,
      );

      _categoryCache[normalizedCategory] = model;
      emit(NewsLoaded(model: model));
    } catch (error) {
      emit(NewsError(message: error.toString()));
    }
  }

  Future<void> searchArticles({required String query}) async {
    final searchNumber = ++_latestSearchNumber;
    emit(SearchLoading());
    try {
      final model = await NewsService.searchNews(query: query);

      if (searchNumber != _latestSearchNumber) return;
      emit(SearchLoaded(model: model));
    } catch (error) {
      if (searchNumber != _latestSearchNumber) return;
      emit(SearchError(message: error.toString()));
    }
  }
}
