import 'package:bloc/bloc.dart';
import 'package:news_cubit_2/models/news_model.dart';

import '../services/news_service.dart';
import 'news_state.dart';


class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  int _latestSearchNumber = 0;
  final Map<String, NewsModel> _categoryCache = {};
  final Map<String, DateTime> _categoryCacheTimes = {};

  void invalidateSearch() {
    _latestSearchNumber++;
  }

  void clearSearch() {
    invalidateSearch();
    emit(SearchInitial());
  }

  Future<void> getArticles({
    required String category,
    bool forceRefresh = false,
  }) async {
    final normalizedCategory = category.toLowerCase();

    final cachedModel = _categoryCache[normalizedCategory];
    final cachedAt = _categoryCacheTimes[normalizedCategory];

    final cacheIsFresh =
        cachedModel != null &&
            cachedAt != null &&
            DateTime.now().difference(cachedAt) < const Duration(minutes: 10);

    // Use fresh cached articles unless the user explicitly requested a refresh.
    if (cacheIsFresh && !forceRefresh) {
      emit(NewsLoaded(model: cachedModel));
      return;
    }

    // Keep the current list visible during pull-to-refresh if we have cached data.
    // Show the normal loading screen for a first fetch or an expired-cache fetch.
    if (!forceRefresh || cachedModel == null) {
      emit(NewsLoading());
    }

    try {
      final model = await NewsService.getNews(
        category: normalizedCategory,
      );

      _categoryCache[normalizedCategory] = model;
      _categoryCacheTimes[normalizedCategory] = DateTime.now();

      emit(NewsLoaded(model: model));
    } catch (error) {
      emit(NewsError(message: error.toString()));

      // If refreshing failed, restore the cached articles instead of leaving
      // the category screen empty.
      if (cachedModel != null) {
        emit(NewsLoaded(model: cachedModel));
      }
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
