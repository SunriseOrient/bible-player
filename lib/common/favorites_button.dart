import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/music_data.dart';
import '../notifier/favorites_model.dart';

class FavoritesButton extends StatelessWidget {
  final MusicSection section;

  const FavoritesButton(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    FavoritesModel favoritesModel = Get.find<FavoritesModel>();
    return IconButton(
      onPressed: () {
        if (favoritesModel.has(section.id)) {
          favoritesModel.remove(section.id);
        } else {
          favoritesModel.add(section.id, section);
        }
      },
      icon: GetBuilder<FavoritesModel>(
        builder: (favoritesModel) {
          if (favoritesModel.has(section.id)) {
            return const Icon(
              Icons.favorite,
              color: Colors.red,
            );
          } else {
            return const Icon(
              Icons.favorite_border,
              color: Colors.red,
            );
          }
        },
      ),
    );
  }
}
