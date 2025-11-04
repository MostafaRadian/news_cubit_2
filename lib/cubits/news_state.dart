import '../models/news_model.dart';

abstract class NewsState {}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState{
  final NewsModel model;
  NewsLoaded({required this.model});
}

final class NewsError extends NewsState{
  final String message;
  NewsError({required this.message});
}

final class SearchLoading extends NewsState {}

final class SearchLoaded extends NewsState{
  final NewsModel model;
  SearchLoaded({required this.model});
}

final class SearchError extends NewsState{
  final String message;
  SearchError({required this.message});
}





