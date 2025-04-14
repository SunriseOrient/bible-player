import 'package:audio_service/audio_service.dart';
import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:bible_player/service/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'notifier/favorites_model.dart';
import 'notifier/music_model.dart';
import 'notifier/one_sentence_model.dart';
import 'notifier/player_model.dart';
import 'page/navigation.dart';
import 'page/settings.dart';
import 'service/keep_cache.dart';
import 'service/audio_player_handler.dart';
import 'service/update_check.dart';

void main() {
  // 确保 package_info_plus、flutter_downloader 插件初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 覆盖 android 系统样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // 去除顶部状态栏灰色背景
      statusBarColor: Colors.transparent,
      // 设置顶部状态栏文字颜色（安卓）
      statusBarIconBrightness: Brightness.dark,
      // 设置顶部状态栏文字颜色（苹果）
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MainApp());
  _initEvn();
  // 更新检查
  UpdateCheck.checkUpdate();
}

/// 环境初始化
_initEvn() async {
  MusicModel musicModel = Get.put(MusicModel());
  OneSentenceModel oneSentenceModel = Get.put(OneSentenceModel());
  Get.put(FavoritesModel());
  Get.put(PlayerModel());
  // if (!await networkCheck()) return;
  musicModel.loadMusicSource();
  oneSentenceModel.loadOneSentence();

  // 初始化后台播放服务
  await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.bible_player.channel.audio',
      androidNotificationChannelName: 'Bible Player',
      // 标记为持续播放，播放中无法从控制面板中移除播放卡片
      androidNotificationOngoing: true,
    ),
  );

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
        "/settings": (context) => const Settings(),
      },
    );
  }
}
