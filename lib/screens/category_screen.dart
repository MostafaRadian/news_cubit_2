import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/widgets/article_item.dart';

import '../cubits/news_cubit.dart';
import '../cubits/news_state.dart';
import '../models/news_model.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  const CategoryScreen({required this.category, super.key});

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
          return Center(child: CircularProgressIndicator());
        } else if (state is NewsLoaded) {
          List<Article> articles = state.model.articles;
          return RefreshIndicator(
            onRefresh: () {
              return context.read<NewsCubit>().getArticles(
                category: category,
                forceRefresh: true,
              );
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleItem(article: articles[index]);
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
