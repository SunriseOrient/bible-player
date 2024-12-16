import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/music_data.dart';
import '../notifier/player_model.dart';
import 'favorites_button.dart';
import 'playing_icon.dart';

class PlayList extends StatelessWidget {
  final PlayerModel playerModel = Get.find<PlayerModel>();
  final List<MusicSection> sections;
  final Function? listTileTap;

  PlayList(this.sections, {super.key, this.listTileTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        MusicSection section = sections[index];
        return GetBuilder<PlayerModel>(
            id: "currentMusicSection",
            builder: (playerModel) {
              return ListTile(
                title: Text(section.name),
                leading: section.id == playerModel.currentMusicSection?.id
                    ? PlayingIcon(playerModel.player.playingStream)
                    : null,
                trailing: FavoritesButton(
                  section,
                ),
                onTap: () {
                  if (listTileTap != null) {
                    listTileTap!(section);
                  }
                },
              );
            });
      },
    );
  }
}
