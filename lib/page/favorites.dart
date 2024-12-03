import 'package:bible_player/notifier/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/favorites_button.dart';
import '../entity/music_data.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("我喜欢"),
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
              child: GetBuilder<FavoritesModel>(builder: (favoritesModel) {
                List<MusicSection> sections = favoritesModel.sections;
                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(sections[index].name),
                      trailing: FavoritesButton(sections[index]),
                      onTap: () {
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
