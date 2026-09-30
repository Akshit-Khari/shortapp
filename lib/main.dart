import 'package:flutter/material.dart';

import 'screens/sorting_screen.dart';

void main() {
  runApp(const SortingApp());
}

class SortingApp extends StatelessWidget {
  const SortingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sorting Visualizer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF08111F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF08111F),
          foregroundColor: Colors.white,
        ),
        cardColor: const Color(0xFF0E1A2B),
      ),
      home: const SortingScreen(),
    );
  }
}
