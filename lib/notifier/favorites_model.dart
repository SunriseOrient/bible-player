import 'package:get/get.dart';

import '../entity/music_data.dart';

class FavoritesModel extends GetxController {
  final Map<String, MusicSection> _sectionsMap = {};

  List<MusicSection> get sections => _sectionsMap.values.toList();

  remove(String id) {
    _sectionsMap.remove(id);
    update();
  }

  add(String id, MusicSection section) {
    _sectionsMap.addAll({id: section});
    update();
  }

  has(String id) {
    return _sectionsMap.containsKey(id);
  }
}
