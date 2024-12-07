import 'package:bible_player/notifier/music_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/play_list.dart';
import '../common/play_panel.dart';
import '../entity/music_data.dart';
import '../entity/play_mode.dart';
import '../notifier/player_model.dart';

class MusicList extends StatelessWidget {
  final PlayerModel playerModel = Get.find<PlayerModel>();

  MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: GetBuilder<MusicModel>(
          builder: (musicModel) {
            MusicChapter? chapter = musicModel.getCurrentChapter();
            return Text(chapter != null ? chapter.name : '');
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                    ),
                    onPressed: () {
                      playerModel.playAll(PlayListType.convention);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.play_circle),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("全部播放"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: GetBuilder<MusicModel>(
                builder: (musicModel) {
                  MusicChapter? chapter = musicModel.getCurrentChapter();
                  List<MusicSection> sections =
                      chapter != null ? chapter.sections : [];
                  return PlayList(
                    sections,
                    listTileTap: (section) {
                      playerModel.play(section, PlayListType.convention);
                      Navigator.pushNamed(context, "/play_controller");
                    },
                  );
                },
              ),
            ),
            PlayPanel()
          ],
        ),
      ),
    );
  }
}
