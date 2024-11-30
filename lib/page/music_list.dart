import 'package:bible_player/notifier/music_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/favorites_button.dart';
import '../entity/music_data.dart';
import '../notifier/player_model.dart';

class MusicList extends StatelessWidget {
  const MusicList({super.key});

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
        title: Consumer<MusicModel>(builder: (context, musicModel, child) {
          MusicChapter? chapter = musicModel.getCurrentChapter();
          return Text(chapter != null ? chapter.name : '');
        }),
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
                    onPressed: () => {},
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
              child:
                  Consumer<MusicModel>(builder: (context, musicModel, child) {
                MusicChapter? chapter = musicModel.getCurrentChapter();
                List<MusicSection> sections =
                    chapter != null ? chapter.sections : [];
                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(sections[index].name),
                      // leading: const PlayingIcon(),
                      trailing: FavoritesButton(
                        sections[index],
                      ),
                      onTap: () {
                        context
                            .read<MusicModel>()
                            .updateIndex(sectionIndex: index);
                        context.read<PlayerModel>().play(sections[index]);
                        Navigator.pushNamed(context, "/play_controller");
                      },
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
