import 'package:bible_player/notifier/music_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/play_list.dart';
import '../common/play_panel.dart';
import '../entity/music_data.dart';
import '../notifier/player_model.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  MusicChapter? chapter;

  _loadRouteArguments() {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args == null) return;
    if (args["groupIndex"] == null) return;
    if (args["chapterIndex"] == null) return;
    MusicChapter musicChapter = Get.find<MusicModel>()
        .source
        .data[args["groupIndex"]]
        .chapters[args["chapterIndex"]];
    setState(() {
      chapter = musicChapter;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadRouteArguments();
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(chapter != null ? chapter!.name : ''),
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
                      if (chapter == null) return;
                      Get.find<PlayerModel>().playAll(chapter!);
                      Navigator.pushNamed(context, "/play_controller");
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
              child: PlayList(
                chapter?.sections ?? [],
                listTileTap: (section) {
                  Get.find<PlayerModel>().play(section);
                  Navigator.pushNamed(context, "/play_controller");
                },
              ),
            ),
            const PlayPanel()
          ],
        ),
      ),
    );
  }
}
