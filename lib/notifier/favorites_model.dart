import 'package:get/get.dart';

import '../entity/music_data.dart';

class FavoritesModel extends GetxController {
  static String playListId = "-1_-1";
  late MusicChapter musicChapter;

  FavoritesModel() {
    musicChapter = MusicChapter("我喜欢", playListId, "", "", []);
  }

  Map<String, MusicSection> get _sectionsMap =>
      {for (var item in musicChapter.sections) item.id: item};
  List<MusicSection> get sections => musicChapter.sections;

  remove(String id) {
    musicChapter.sections.removeWhere((item) => item.id == id);
    update();
  }

  add(MusicSection section) {
    musicChapter.sections.add(section);
    update();
  }

  has(String id) {
    return _sectionsMap.containsKey(id);
  }

  recoveredMusicChapter(MusicChapter musicChapter) {
    this.musicChapter = musicChapter;
    update();
  }
}
