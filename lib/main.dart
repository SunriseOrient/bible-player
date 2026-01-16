import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bible_player/page/music_list.dart';
import 'package:bible_player/page/play_controller.dart';
import 'package:bible_player/service/baidu_mob_stat.dart';
import 'package:bible_player/service/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'notifier/favorites_model.dart';
import 'notifier/music_model.dart';
import 'notifier/one_sentence_model.dart';
import 'notifier/player_model.dart';
import 'page/navigation.dart';
import 'page/setting.dart';
import 'service/cache_service.dart';
import 'service/audio_player_handler.dart';
import 'service/update_service.dart';

main() async {
  // 确保 框架已经初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化系统样式
  _initSystemStyle();
  // 加载Models
  _loadModels();

  runApp(const MainApp());

  // if (!await networkCheck()) return;
  // 初始化环境model
  _initModels();
  // 初始化后台播放卡片
  _initAudioBackgroundCard();
  // 初始化百度统计
  _initBaiduAnalytics();

  // 更新检查
  UpdateService.check();
  // 初始化缓存服务
  CacheService.init();
}

// 初始化后台播放卡片
_initAudioBackgroundCard() async {
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
}

// 初始化环境model
_initSystemStyle() {
  if (Platform.isAndroid) {
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
  }
}

// 加载Models
_loadModels() async {
  Get.put(MusicModel());
  Get.put(OneSentenceModel());
  Get.put(FavoritesModel());
  Get.put(PlayerModel());
  // Get.put(SettingModel());
}

// 环境初始化
_initModels() async {
  Get.find<MusicModel>().loadMusicSource();
  Get.find<OneSentenceModel>().loadOneSentence();
}

// 初始化百度统计
_initBaiduAnalytics() async {
  if (kReleaseMode) {
    if (Platform.isAndroid) {
      await BaiduMobStat().init();
    }

    await BaiduMobStat().setApiKey(androidKey: 'cf9256fff0', iosKey: '');

    String channelName = 'default';
    if (Platform.isAndroid) channelName += '-android';
    if (Platform.isIOS) channelName += '-ios';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    await BaiduMobStat().setAppChannel(channelName);
    await BaiduMobStat().setAppVersionName(packageInfo.version);
    await BaiduMobStat().setDebug(!kReleaseMode);

    final String? testDeviceId = await BaiduMobStat().getTestDeviceId();
    debugPrint("TestDeviceId: $testDeviceId");
  }
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
        "/setting": (context) => const Setting(),
      },
    );
  }
}
