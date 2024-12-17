import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../entity/music_data.dart';
import '../service/toast.dart';

class MusicModel extends GetxController {
  late MusicSource source;

  MusicModel() {
    source = MusicSource([]);
  }

  Future<void> loadMusicSource() async {
    try {
      http.Response response =
          await http.get(Uri.parse('${Config.httpBase}/playlists.json'));
      List<dynamic> jsonMap =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      source = MusicSource.fromJson(jsonMap);
      update();
    } catch (e) {
      Toast.showMessage("获取数据源失败");
    }
  }
}
