import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_cubit_2/screens/home_screen.dart';

import 'cubits/news_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..getArticles(category: 'general'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Brief',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(
                seedColor: const Color(0xFFB6A1FF),
                brightness: Brightness.dark,
              ).copyWith(
                primary: const Color(0xFFB6A1FF),
                onPrimary: const Color(0xFF17151F),
                surface: const Color(0xFF191A1F),
                onSurface: const Color(0xFFF0EFF4),
                outline: const Color(0xFF303138),
              ),
          scaffoldBackgroundColor: const Color(0xFF101114),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF101114),
            foregroundColor: Color(0xFFF0EFF4),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            toolbarHeight: 58,
            titleTextStyle: TextStyle(
              color: Color(0xFFF0EFF4),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFF292A30),
            thickness: 1,
            space: 1,
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFFB6A1FF),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
