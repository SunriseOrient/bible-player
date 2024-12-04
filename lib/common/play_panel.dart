import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';
import '../notifier/music_model.dart';
import '../notifier/player_model.dart';

class PlayPanel extends StatefulWidget {
  @override
  State<PlayPanel> createState() => _PlayPanelState();
}

class _PlayPanelState extends State<PlayPanel> {
  MusicModel musicModel = Get.find<MusicModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerModel>(
        id: "currentSection",
        builder: (playerModel) {
          MusicSection? currentSection = playerModel.currentSection;
          if (currentSection == null) {
            return const SizedBox.shrink();
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -1),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListTile(
              title: Text(currentSection.name),
              subtitle:
                  Text(musicModel.getSubtitleBySectionId(currentSection.id)),
              trailing: StreamBuilder<PlayerState>(
                stream: playerModel.player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final playing = playerState?.playing;
                  if (playing == true) {
                    return GestureDetector(
                      onTap: () => playerModel.player.pause(),
                      child: const Icon(
                        Icons.pause_circle,
                        color: Colors.red,
                        size: 42,
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (playerModel.loadedListId == null) {
                          playerModel.play(currentSection);
                        } else {
                          playerModel.player.play();
                        }
                      },
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.red,
                        size: 42,
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                if (playerModel.loadedListId == null) {
                  playerModel.play(currentSection, noPlay: true);
                }
                Navigator.pushNamed(context, "/play_controller");
              },
            ),
          );
        });
  }
}
