import 'package:flutter/material.dart';

import '../common/playing_icon.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text('陋室铭'),
        centerTitle: true,
      ),
      body: Column(
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
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: const Text("弟子规"),
                  leading: const PlayingIcon(),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite),
                    // icon: const Icon(Icons.favorite_border),
                    color: Colors.red,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
