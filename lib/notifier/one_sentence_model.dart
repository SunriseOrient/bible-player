import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/toast.dart';

/// 每日金句模块
class OneSentenceModel extends GetxController {
  String book = "";
  int chapter = 0;
  int verse = 0;
  String text = "";

  /// 加载每日金句
  Future<void> loadOneSentence() async {
    try {
      http.Response response =
          await http.get(Uri.parse('https://bible-api.com/data/cuv/random'));
      dynamic jsonMap =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      if (jsonMap["random_verse"] == null) return;
      if (jsonMap["random_verse"]["text"] == null) return;
      book = jsonMap["random_verse"]['book'];
      chapter = jsonMap["random_verse"]['chapter'];
      verse = jsonMap["random_verse"]['verse'];
      text = jsonMap["random_verse"]['text'];
      update();
    } catch (e) {
      Toast.showMessage("获取每日金句失败");
    }
  }
}
