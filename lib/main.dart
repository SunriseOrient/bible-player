import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifier/favorites_model.dart';
import 'notifier/music_model.dart';
import 'notifier/player_model.dart';
import 'page/navigation.dart';
import 'service/keep_cache.dart';

void main() {
  _initEvn();
  runApp(const MainApp());
}

_initEvn() async {
  Get.put(MusicModel()).loadMusicSource();
  Get.put(FavoritesModel());
  Get.put(PlayerModel());
  KeepCache().run();
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
