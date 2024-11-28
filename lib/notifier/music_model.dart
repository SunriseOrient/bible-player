import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../entity/music_data.dart';

class MusicModel extends ChangeNotifier {
  MusicSource source = MusicSource([]);
  int _groupIndex = -1;
  int _chapterIndex = -1;
  int _sectionIndex = -1;

  Future<MusicSource> loadMusicSource() async {
    http.Response response =
        await http.get(Uri.parse('${Config.httpBase}/playlists.json'));
    List<dynamic> jsonMap = jsonDecode(response.body);
    source = MusicSource.fromJson(jsonMap);
    notifyListeners();
    return source;
  }

  void updateIndex({int? groupIndex, int? chapterIndex, int? sectionIndex}) {
    if (groupIndex != null) {
      _groupIndex = groupIndex;
    }
    if (chapterIndex != null) {
      _chapterIndex = chapterIndex;
    }
    if (sectionIndex != null) {
      _sectionIndex = sectionIndex;
    }
    notifyListeners();
  }

  MusicGroup? getCurrentGroup() {
    return _groupIndex > -1 ? source.data[_groupIndex] : null;
  }

  MusicChapter? getCurrentChapter() {
    MusicGroup? group = getCurrentGroup();
    if (group == null) return null;
    return _chapterIndex > -1 ? group.chapters[_chapterIndex] : null;
  }

  MusicSection? getCurrentSection() {
    MusicGroup? group = getCurrentGroup();
    if (group == null) return null;
    MusicChapter? chapter = getCurrentChapter();
    if (chapter == null) return null;
    return _sectionIndex > -1 ? chapter.sections[_sectionIndex] : null;
  }
}
