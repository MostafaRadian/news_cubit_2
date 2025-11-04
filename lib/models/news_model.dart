class Article {
  final String source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });
}

class NewsModel {
  final List<Article> articles;

  NewsModel({required this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> tempList = json['articles'];
    final List<Article> articlesList = tempList.map((article) {
      return Article(
        source: article['source']['name'] ?? '',
        author: article['author'] ?? '',
        title: article['title'] ?? '',
        description: article['description'] ?? '',
        url: article['url'] ?? '',
        urlToImage: article['urlToImage'] ?? '' ,
        publishedAt: article['publishedAt'] ?? '',
      );
    }).toList();
    return NewsModel(articles: articlesList);
  }
}
