import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_cubit_2/models/news_model.dart';

import '../services/news_service.dart';
import 'news_state.dart';


class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

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
    emit(SearchLoading());
    try{
      NewsModel tempModel = await NewsService.searchNews(query: query);
      emit(SearchLoaded(model: tempModel));
    }catch(error){
      emit(SearchError(message: error.toString()));
    }
  }
}
