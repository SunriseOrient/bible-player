import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../entity/music_data.dart';

class MusicModel extends GetxController {
  MusicSource source = MusicSource([]);
  int _groupIndex = -1;
  int _chapterIndex = -1;

  int get groupIndex => _groupIndex;
  int get chapterIndex => _chapterIndex;

  String get subtitle => getSubtitleByIndex(_groupIndex, _chapterIndex);

  Future<void> loadMusicSource() async {
    http.Response response =
        await http.get(Uri.parse('${Config.httpBase}/playlists.json'));
    List<dynamic> jsonMap =
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
    source = MusicSource.fromJson(jsonMap);
    update();
  }

  void updateIndex({int? groupIndex, int? chapterIndex}) {
    if (groupIndex != null) {
      _groupIndex = groupIndex;
    }
    if (chapterIndex != null) {
      _chapterIndex = chapterIndex;
    }
    update();
  }

  MusicGroup? getCurrentGroup() {
    return _groupIndex > -1 ? source.data[_groupIndex] : null;
  }

  MusicChapter? getCurrentChapter() {
    MusicGroup? group = getCurrentGroup();
    if (group == null) return null;
    return _chapterIndex > -1 ? group.chapters[_chapterIndex] : null;
  }

  String getSubtitleByIndex(groupIndex, chapterIndex) {
    MusicGroup? group = groupIndex > -1 ? source.data[groupIndex] : null;
    if (group == null) return "";
    MusicChapter? chapter =
        chapterIndex > -1 ? group.chapters[chapterIndex] : null;
    if (chapter == null) return "";
    return "${group.title}/${chapter.name}";
  }

  String getSubtitleBySectionId(String id) {
    List<String> idArray = id.split("_");
    return getSubtitleByIndex(int.parse(idArray[0]), int.parse(idArray[1]));
  }
}
