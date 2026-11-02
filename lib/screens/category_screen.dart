import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/widgets/article_card.dart';

import '../cubits/news_cubit.dart';
import '../cubits/news_state.dart';
import '../models/news_model.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  const CategoryScreen({required this.category, super.key});

  Color get _accentColor => switch (category.toLowerCase()) {
    'business' => const Color(0xFF61C9E8),
    'health' => const Color(0xFF4FD1A5),
    'entertainment' => const Color(0xFFFF6F9F),
    _ => const Color(0xFFB6A1FF),
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state is NewsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading the latest stories',
                  style: TextStyle(color: Color(0xFF92949D)),
                ),
              ],
            ),
          );
        } else if (state is NewsLoaded) {
          final List<Article> articles = state.model.articles;
          return RefreshIndicator(
            onRefresh: () {
              return context.read<NewsCubit>().getArticles(
                category: category,
                forceRefresh: true,
              );
            },
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: articles.isEmpty ? 2 : articles.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                if (index == 0) return _buildFeedHeading();

                if (articles.isEmpty) {
                  return const SizedBox(
                    height: 190,
                    child: Center(
                      child: Text(
                        'No stories in this section yet.',
                        style: TextStyle(color: Color(0xFF92949D)),
                      ),
                    ),
                  );
                }
                final articleIndex = index - 1;
                final article = articles[articleIndex];
                if (articleIndex == 0) {
                  return FeaturedArticleCard(
                    article: article,
                    accentColor: _accentColor,
                  );
                }
                return ArticleCard(article: article, accentColor: _accentColor);
              },
            ),
          );
        } else if (state is NewsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 34,
                    color: Color(0xFF7A807D),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Couldn’t load these stories',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF0EFF4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Check your connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF92949D)),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => context.read<NewsCubit>().getArticles(
                      category: category,
                      forceRefresh: true,
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildFeedHeading() {
    final now = DateTime.now();
    const weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 8),
      padding: const EdgeInsets.fromLTRB(17, 15, 14, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _accentColor.withValues(alpha: 0.32)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accentColor.withValues(alpha: 0.27),
            _accentColor.withValues(alpha: 0.10),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}',
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _categoryTitle,
                  style: const TextStyle(
                    color: Color(0xFFF0EFF4),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _categorySubtitle,
                  style: const TextStyle(
                    color: Color(0xFFCFCDD5),
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor.withValues(alpha: 0.16),
              border: Border.all(color: _accentColor.withValues(alpha: 0.28)),
            ),
            child: Icon(_categoryIcon, size: 23, color: _accentColor),
          ),
        ],
      ),
    );
  }

  IconData get _categoryIcon => switch (category.toLowerCase()) {
    'business' => Icons.business_rounded,
    'health' => Icons.health_and_safety_outlined,
    'entertainment' => Icons.movie_creation_outlined,
    _ => Icons.home_rounded,
  };

  String get _categorySubtitle => switch (category.toLowerCase()) {
    'business' => 'Markets, companies & the economy',
    'health' => 'Health, science & wellbeing',
    'entertainment' => 'Culture, film & the arts',
    _ => 'The latest stories from around the world',
  };

  String get _categoryTitle {
    if (category.toLowerCase() == 'general') return 'Home';
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }
}
