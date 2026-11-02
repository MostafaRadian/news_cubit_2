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

  final List<Widget> pages = [
    const CategoryScreen(category: "General"),
    const CategoryScreen(category: "Business"),
    const SearchScreen(),
    const CategoryScreen(category: "Health"),
    const CategoryScreen(category: "Entertainment"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Daily Brief')),
      body: pages[currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: const Color(0xFF191A1F),
        selectedItemColor: const Color(0xFFB6A1FF),
        unselectedItemColor: const Color(0xFF858791),
        selectedColorOpacity: 0.14,
        itemShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        itemPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
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
            selectedColor: const Color(0xFFB6A1FF),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.business_rounded),
            title: const Text("Business"),
            selectedColor: const Color(0xFF61C9E8),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search_rounded),
            title: const Text("Search"),
            selectedColor: const Color(0xFFFFB454),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.health_and_safety_outlined),
            title: const Text("Health"),
            selectedColor: const Color(0xFF4FD1A5),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.movie_creation_outlined),
            title: const Text("Entertainment"),
            selectedColor: const Color(0xFFFF6F9F),
          ),
        ],
      ),
    );
  }
}
