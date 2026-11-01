import 'package:bloc/bloc.dart';
import 'package:news_cubit_2/models/news_model.dart';

import '../services/news_service.dart';
import 'news_state.dart';


class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  int _latestSearchNumber = 0;

  void invalidateSearch() {
    _latestSearchNumber++;
  }

  void clearSearch() {
    invalidateSearch();
    emit(SearchInitial());
  }

  Future<void> getArticles({required String category}) async {
    emit(NewsLoading());
    try {
      NewsModel tempModel = await NewsService.getNews(category: category);
      emit(NewsLoaded(model: tempModel));
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
