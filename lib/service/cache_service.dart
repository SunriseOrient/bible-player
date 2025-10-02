import 'dart:convert';

import 'package:bible_player/notifier/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/music_data.dart';
import '../entity/setting_data.dart';
import '../notifier/player_model.dart';
import '../notifier/setting_model.dart';

// 缓存服务
class CacheService {
  static late SharedPreferences prefs;

  // 我喜欢模块缓存标识
  static String favoritesMusicChapter = "FAVORITES_MUSIC_CHAPTER";

  // 播放器当前播放章节和节缓存标识
  static String currentMusicChapter = "CURRENT_MUSIC_CHAPTER";
  static String currentMusicSection = "CURRENT_MUSIC_SECTION";

  // 设置数据缓存标识
  static String settingData = "SETTING_DATA";

  static init() async {
    prefs = await SharedPreferences.getInstance();
    _listeningModification();
    _loadCache();
  }

  static _listeningModification() {
    _listenFavoritesModelModification();
    _listenPlayerModelModification();
    // _listenSettingDataModification();
  }

  static _loadCache() {
    _loadFavoritesModelCache();
    _loadPlayerModelData();
    // _loadSettingData();
  }

  // 我喜欢数据修改监听
  static _listenFavoritesModelModification() {
    FavoritesModel favoritesModel = Get.find<FavoritesModel>();
    favoritesModel.addListener(() {
      String str = jsonEncode(favoritesModel.musicChapter.toJson());
      prefs.setString(favoritesMusicChapter, str);
    });
  }

  // 我喜欢数据加载
  static _loadFavoritesModelCache() {
    String? favoritesMusicChapterStr = prefs.getString(favoritesMusicChapter);
    debugPrint("favoritesMusicChapterStr: $favoritesMusicChapterStr");
    if (favoritesMusicChapterStr != null) {
      MusicChapter musicChapter =
          MusicChapter.fromJson(jsonDecode(favoritesMusicChapterStr));
      Get.find<FavoritesModel>().recoveredMusicChapter(musicChapter);
    }
  }

  // 设置数据监听
  static _listenSettingDataModification() {
    SettingModel settingModel = Get.find<SettingModel>();
    settingModel.addListenerId("settingChange", () {
      debugPrint(jsonEncode(settingModel.settings!.toJson()));
      prefs.setString(settingData, jsonEncode(settingModel.settings!.toJson()));
    });
  }

  // 设置数据加载
  static _loadSettingData() {
    String? settingDataStr = prefs.getString(settingData);
    if (settingDataStr != null) {
      Get.find<SettingModel>().settings =
          SettingData.fromJson(jsonDecode(settingDataStr));
    }
  }

  // 播放器数据监听
  static _listenPlayerModelModification() {
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

  // 播放器数据加载
  static _loadPlayerModelData() {
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
