import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:flutter/material.dart';

import 'page/navigation.dart';

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
      routes: {
        "/": (context) => Navigation(),
        "/music_list": (context) => MusicList(),
        "/play_controller": (context) => PlayController(),
      },
    );
  }
}
