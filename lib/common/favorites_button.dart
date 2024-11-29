import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/music_data.dart';
import '../notifier/favorites_model.dart';
import '../notifier/music_model.dart';

class FavoritesButton extends StatelessWidget {
  final MusicSection section;
  final int groupIndex;
  final int chapterIndex;

  const FavoritesButton(this.section,
      {super.key, required this.groupIndex, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    FavoritesModel favoritesModel = context.read<FavoritesModel>();
    MusicModel musicModel = context.read<MusicModel>();
    return IconButton(
      onPressed: () {
        if (favoritesModel.has(section.id)) {
          favoritesModel.remove(section.id);
        } else {
          favoritesModel.add(
              section.id,
              FavoriteMusicSection(section,
                  musicModel.getSubtitleByIndex(groupIndex, chapterIndex)));
        }
      },
      icon: Consumer<FavoritesModel>(
        builder: (context, modal, child) {
          if (modal.has(section.id)) {
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
