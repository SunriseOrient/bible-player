import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:bible_player/service/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifier/favorites_model.dart';
import 'notifier/music_model.dart';
import 'notifier/player_model.dart';
import 'page/navigation.dart';
// import 'service/evn_check.dart';
import 'service/keep_cache.dart';

void main() {
  runApp(const MainApp());
  _initEvn();
}

_initEvn() async {
  MusicModel musicModel = Get.put(MusicModel());
  Get.put(FavoritesModel());
  Get.put(PlayerModel());
  // if (!await networkCheck()) return;
  musicModel.loadMusicSource();
  KeepCache();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    Toast.init(navigatorKey);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          elevation: 0,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
      ),
      routes: {
        "/": (context) => const Navigation(),
        "/music_list": (context) => const MusicList(),
        "/play_controller": (context) => const PlayController(),
      },
    );
  }
}
