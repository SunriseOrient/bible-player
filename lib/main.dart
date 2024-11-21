import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/home.dart';
import 'page/music_list.dart';
import 'page/play_controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          elevation: 0,
        ),
      ),
      routes: {"/": (context) => Home()},
    );
  }
}
