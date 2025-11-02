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
    final List<dynamic> articleList = json['articles'];
    final List<Article> articles = articleList.map((article) {
      return Article(
        source: article['source']['name'],
        author: article['author'],
        title: article['title'],
        description: article['description'],
        url: article['url'],
        urlToImage: article['urlToImage'],
        publishedAt: article['publishedAt'],
      );
    }).toList();
    return NewsModel(articles: articles);
  }
}
