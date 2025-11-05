import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/widgets/article_item.dart';

import '../cubits/news_cubit.dart';
import '../cubits/news_state.dart';
import '../models/news_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SearchBar(
            leading: Icon(Icons.search),
            hintText: 'Search',
            onChanged: (value) {
              if (value.isNotEmpty) {
                context.read<NewsCubit>().searchArticles(query: value);
              }
            },
          ),
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
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: LinearProgressIndicator(),
                  );
                }
                if (state is SearchLoaded) {
                  List<Article> articles = state.model.articles;
                  if (articles.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        "No results found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleItem(article: article);
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
