import 'package:flutter/material.dart';
import 'package:news_cubit_2/screens/category_screen.dart';
import 'package:news_cubit_2/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex, items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.business_rounded), label: "Business"),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_outlined), label: "Health"),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: "Entertainment"),
      ],
    ),);
  }
}
