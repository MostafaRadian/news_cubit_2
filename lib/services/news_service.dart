import 'package:dio/dio.dart';
import 'package:news_cubit_2/models/news_model.dart';

class NewsService {
  static Dio dio = Dio();

  static Future<NewsModel> getNews({required String category}) async {
    try {
      Response response = await dio.get(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=a410b1724f84452c8df8a810efe34642",
      );
      return NewsModel.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception("Network error: ${dioError.message}");
    } catch (otherError) {
      throw Exception("Something went wrong: $otherError");
    }
  }

  static Future<NewsModel> searchNews({required String query}) async {
    try {
      Response response = await dio.get(
        "https://newsapi.org/v2/everything?q=$query&apiKey=a410b1724f84452c8df8a810efe34642",
      );
      return NewsModel.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception("Network error: ${dioError.message}");
    } catch (otherError) {
      throw Exception("Something went wrong: $otherError");
    }
  }
}
