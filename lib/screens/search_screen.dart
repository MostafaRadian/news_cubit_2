import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/widgets/article_card.dart';

import '../cubits/news_cubit.dart';
import '../cubits/news_state.dart';
import '../models/news_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: const Color(0xFFFFB454).withValues(alpha: 0.32),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x44FFB454), Color(0x1AFFB454)],
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SEARCH',
                        style: TextStyle(
                          color: Color(0xFFFFB454),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Find a story',
                        style: TextStyle(
                          color: Color(0xFFF0EFF4),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.search_rounded, size: 25, color: Color(0xFFFFB454)),
              ],
            ),
          ),
          SearchBar(
            leading: const Icon(Icons.search_rounded, color: Color(0xFFFFB454)),
            hintText: 'Search stories or topics',
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFF191A1F)),
            side: const WidgetStatePropertyAll(
              BorderSide(color: Color(0xFF303138)),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            hintStyle: const WidgetStatePropertyAll(
              TextStyle(color: Color(0xFF92949D), fontSize: 14),
            ),
            onChanged: (value) {
              _debounce?.cancel();

              final query = value.trim();
              if (query.isEmpty) {
                context.read<NewsCubit>().clearSearch();
                return;
              }

              // Ignore any older request while this query is being debounced.
              context.read<NewsCubit>().invalidateSearch();

              _debounce = Timer(const Duration(milliseconds: 400), () {
                if (!mounted) return;
                context.read<NewsCubit>().searchArticles(query: query);
              });
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocConsumer<NewsCubit, NewsState>(
              listener: (context, state) {
                if (state is SearchError) {
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
                if (state is SearchLoading) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 14),
                        Text(
                          'Looking for stories',
                          style: TextStyle(color: Color(0xFF92949D)),
                        ),
                      ],
                    ),
                  );
                }
                if (state is SearchLoaded) {
                  final List<Article> articles = state.model.articles;
                  if (articles.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 34,
                            color: Color(0xFF858791),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No stories found',
                            style: TextStyle(
                              color: Color(0xFFF0EFF4),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Try a different search.',
                            style: TextStyle(color: Color(0xFF92949D)),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: articles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      return ArticleCard(
                        article: articles[index],
                        accentColor: const Color(0xFFFFB454),
                      );
                    },
                  );
                }
                if (state is SearchError) {
                  return const Center(
                    child: Text(
                      'Search couldn’t be completed. Try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF92949D)),
                    ),
                  );
                }

                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.newspaper_rounded,
                        size: 34,
                        color: Color(0xFF858791),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Find a story',
                        style: TextStyle(
                          color: Color(0xFFF0EFF4),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Search by topic, place, or headline.',
                        style: TextStyle(color: Color(0xFF92949D)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
