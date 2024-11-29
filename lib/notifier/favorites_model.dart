import 'package:flutter/material.dart';

import '../entity/music_data.dart';

class FavoritesModel extends ChangeNotifier {
  final Map<String, FavoriteMusicSection> _sectionsMap = {};

  List<FavoriteMusicSection> get sections => _sectionsMap.values.toList();

  remove(String id) {
    _sectionsMap.remove(id);
    notifyListeners();
  }

  add(String id, FavoriteMusicSection section) {
    _sectionsMap.addAll({id: section});
    notifyListeners();
  }

  has(String id) {
    return _sectionsMap.containsKey(id);
  }
}
