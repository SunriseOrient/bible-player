import 'dart:convert';

import 'package:bible_player/notifier/favorites_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/music_data.dart';
import '../notifier/player_model.dart';

/// 播放状态缓存服务
class KeepCache {
  late SharedPreferences prefs;

  String favoritesMusicChapter = "FAVORITES_MUSIC_CHAPTER";

  String currentMusicChapter = "CURRENT_MUSIC_CHAPTER";
  String currentMusicSection = "CURRENT_MUSIC_SECTION";

  KeepCache() {
    _run();
  }

  _run() async {
    prefs = await SharedPreferences.getInstance();
    _listeningModification();
    _loadCache();
  }

  _listeningModification() {
    FavoritesModel favoritesModel = Get.find<FavoritesModel>();
    favoritesModel.addListener(() {
      String str = jsonEncode(favoritesModel.musicChapter.toJson());
      prefs.setString(favoritesMusicChapter, str);
    });
    //
    PlayerModel playerModel = Get.find<PlayerModel>();
    playerModel.addListenerId("currentMusicChapter", () {
      if (playerModel.currentMusicChapter == null) return;
      prefs.setString(currentMusicChapter,
          jsonEncode(playerModel.currentMusicChapter!.toJson()));
    });
    playerModel.addListenerId("currentMusicSection", () {
      if (playerModel.currentMusicSection == null) return;
      prefs.setString(currentMusicSection,
          jsonEncode(playerModel.currentMusicSection!.toJson()));
    });
  }

  _loadCache() {
    String? favoritesMusicChapterStr = prefs.getString(favoritesMusicChapter);
    if (favoritesMusicChapterStr != null) {
      MusicChapter musicChapter =
          MusicChapter.fromJson(jsonDecode(favoritesMusicChapterStr));
      Get.find<FavoritesModel>().recoveredMusicChapter(musicChapter);
    }
    // 优先获取MusicSection以便初始化MusicChapter时可以正确的懒加载
    String? currentMusicSectionStr = prefs.getString(currentMusicSection);
    if (currentMusicSectionStr != null) {
      MusicSection musicSection =
          MusicSection.fromJson(jsonDecode(currentMusicSectionStr));
      Get.find<PlayerModel>().recoveredCurrentMusicSection(musicSection);
    }
    //
    String? currentMusicChapterStr = prefs.getString(currentMusicChapter);
    if (currentMusicChapterStr != null) {
      MusicChapter musicChapter =
          MusicChapter.fromJson(jsonDecode(currentMusicChapterStr));
      Get.find<PlayerModel>().recoveredCurrentMusicChapter(musicChapter);
    }
  }
}
