import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/screens/category_screen.dart';
import 'package:news_cubit_2/screens/search_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../cubits/news_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<String?> categories = [
    'general',
    'business',
    null, // Search tab
    'health',
    'entertainment',
  ];

  List<String> titles = [
    "Home",
    "Business",
    "Search",
    "Health",
    "Entertainment",
  ];
  List<Widget> pages = [
    const CategoryScreen(category: "General"),
    const CategoryScreen(category: "Business"),
    const SearchScreen(),
    const CategoryScreen(category: "Health"),
    const CategoryScreen(category: "Entertainment"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        title: Text(titles[currentIndex]),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        onTap: (index) {
          if (index == currentIndex) return;

          final category = categories[index];

          if (category != null) {
            context.read<NewsCubit>().getArticles(category: category);
          }
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.deepPurple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.business_rounded),
            title: const Text("Business"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search_rounded),
            title: const Text("Search"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.health_and_safety_outlined),
            title: const Text("Health"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.movie_creation_outlined),
            title: const Text("Media"),
            selectedColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
