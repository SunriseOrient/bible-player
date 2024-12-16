import 'package:bible_player/notifier/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/play_list.dart';
import '../entity/music_data.dart';
import '../notifier/player_model.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    String title = Get.find<FavoritesModel>().musicChapter.name;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: GetBuilder<FavoritesModel>(builder: (favoritesModel) {
          if (favoritesModel.sections.isEmpty) {
            return const FavoritesEmpty();
          }
          return Column(
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
                        Get.find<PlayerModel>()
                            .playAll(favoritesModel.musicChapter);
                        Navigator.pushNamed(context, "/play_controller");
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.play_circle,
                          ),
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
                child: GetBuilder<FavoritesModel>(builder: (favoritesModel) {
                  List<MusicSection> sections = favoritesModel.sections;
                  return PlayList(sections, listTileTap: (section) {
                    Get.find<PlayerModel>().play(section);
                    Navigator.pushNamed(context, "/play_controller");
                  });
                }),
              )
            ],
          );
        }),
      ),
    );
  }
}

class FavoritesEmpty extends StatelessWidget {
  const FavoritesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_add,
            size: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text("没有喜欢的音频"),
        ],
      ),
    );
  }
}
