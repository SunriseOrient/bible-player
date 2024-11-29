import 'package:bible_player/notifier/favorites_model.dart';
import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier/music_model.dart';
import 'page/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MusicModel>(create: (_) => MusicModel()),
      ChangeNotifierProvider<FavoritesModel>(create: (_) => FavoritesModel()),
    ],
    child: const MainApp(),
  ));
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
        "/": (context) => const Home(),
        "/music_list": (context) => MusicList(),
        "/play_controller": (context) => PlayController(),
      },
    );
  }
}
