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
        return StreamBuilder(
            stream: playerModel.player.currentIndexStream,
            builder: (context, snapshot) {
              int? playingIndex = snapshot.data;
              MusicSection section = sections[index];
              return ListTile(
                title: Text(section.name),
                leading: playingIndex == index
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
