import 'dart:convert';

import 'package:bible_player/notifier/favorites_model.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/music_data.dart';
import '../notifier/player_model.dart';

class KeepCache {
  late SharedPreferences prefs;
  String lastPlaySection = "LAST_PLAY_SECTION";
  String favoritesList = "FAVORITES_LIST";
  String listType = "LIST_TYPE";

  run() async {
    prefs = await SharedPreferences.getInstance();
    _loadCache();
    _listeningModification();
  }

  _listeningModification() {
    FavoritesModel favoritesModel = Get.find<FavoritesModel>();
    favoritesModel.addListener(() {
      List<String> favoritesStringList = favoritesModel.sections
          .map((section) => jsonEncode(section.toJson()))
          .toList();
      prefs.setStringList(favoritesList, favoritesStringList);
    });
    //
    PlayerModel playerModel = Get.find<PlayerModel>();
    playerModel.addListenerId("playingSection", () {
      prefs.setString(
          lastPlaySection, jsonEncode(playerModel.playingSection!.toJson()));
      // prefs.setString(listType, playerModel.loadedListType.toString());
    });
  }

  _loadCache() {
    List<String> favoritesStringList = prefs.getStringList(favoritesList) ?? [];
    Map<String, MusicSection> sectionsMap = {};
    for (var favoritesString in favoritesStringList) {
      MusicSection section = MusicSection.fromJson(jsonDecode(favoritesString));
      sectionsMap[section.id] = section;
    }
    Get.find<FavoritesModel>().recoveredState(sectionsMap);
    //
    String? currentSectionString = prefs.getString(lastPlaySection);
    if (currentSectionString == null) return;
    Get.find<PlayerModel>().setPlayingSection(
        MusicSection.fromJson(jsonDecode(currentSectionString)));
  }
}
