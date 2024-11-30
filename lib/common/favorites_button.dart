import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/music_data.dart';
import '../notifier/favorites_model.dart';

class FavoritesButton extends StatelessWidget {
  final MusicSection section;

  const FavoritesButton(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    FavoritesModel favoritesModel = context.read<FavoritesModel>();
    return IconButton(
      onPressed: () {
        if (favoritesModel.has(section.id)) {
          favoritesModel.remove(section.id);
        } else {
          favoritesModel.add(section.id, FavoriteMusicSection(section));
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
