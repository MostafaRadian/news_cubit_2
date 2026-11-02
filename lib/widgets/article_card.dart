import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../screens/article_webview_screen.dart';

class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final Color accentColor;

  const FeaturedArticleCard({
    required this.article,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final source = article.source.trim();
    final date = _formatArticleDate(article.publishedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Material(
        color: const Color(0xFF191A1F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
          side: BorderSide(color: accentColor.withValues(alpha: 0.38)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ArticleWebViewScreen(article: article),
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: 0.36),
                  const Color(0xFF191A1F),
                  const Color(0xFF15161B),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (source.isNotEmpty || date.isNotEmpty) ...[
                    Row(
                      children: [
                        if (source.isNotEmpty)
                          Flexible(
                            child: Text(
                              source.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        if (source.isNotEmpty && date.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '·',
                              style: TextStyle(color: Color(0xFF9698A1)),
                            ),
                          ),
                        if (date.isNotEmpty)
                          Text(
                            date.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFB0B1B8),
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFF5F3F8),
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (article.description.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFC0C0C8),
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final Color accentColor;

  const ArticleCard({
    required this.article,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final source = article.source.trim();
    final publishedDate = _formatDate(article.publishedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Material(
        color: const Color(0xFF191A1F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF26272E)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ArticleWebViewScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (source.isNotEmpty || publishedDate.isNotEmpty) ...[
                        Row(
                          children: [
                            if (source.isNotEmpty)
                              Flexible(
                                child: Text(
                                  source.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                            if (source.isNotEmpty && publishedDate.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '·',
                                  style: TextStyle(color: Color(0xFF777A84)),
                                ),
                              ),
                            if (publishedDate.isNotEmpty)
                              Text(
                                publishedDate.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF858791),
                                  fontSize: 9,
                                  letterSpacing: 0.3,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFF0EFF4),
                          fontSize: 17,
                          height: 1.28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (article.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF92949D),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildThumbnail(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final imageUrl = article.urlToImage.trim();
    if (imageUrl.isEmpty) return _thumbnailPlaceholder();

    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        memCacheWidth: 216,
        memCacheHeight: 216,
        placeholder: (context, url) => _thumbnailPlaceholder(),
        errorWidget: (context, url, error) => _thumbnailPlaceholder(),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.62),
            accentColor.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 22,
        color: Color(0xFFD8D5E0),
      ),
    );
  }

  String _formatDate(String value) {
    return _formatArticleDate(value);
  }
}

String _formatArticleDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return '';

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}
