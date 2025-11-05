import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/news_cubit.dart';
import '../cubits/news_state.dart';
import '../models/news_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SearchBar(
            leading: Icon(Icons.search),
            hintText: 'Search',
            onChanged: (value) {
              context.read<NewsCubit>().searchArticles(query: value);
            },
          ),
          BlocConsumer<NewsCubit, NewsState>(
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
                return const LinearProgressIndicator();
              }
              if (state is NewsLoaded) {
                List<Article> articles = state.model.articles;
                return Container(
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
                    shrinkWrap: true,
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ListTile(
                        title: Text(article.title),
                        onTap: () {

                        },
                      );
                    },
                  ),
                );
              } else {
                return const Center();
              }
            },
          ),
        ],
      ),
    );
  }
}
