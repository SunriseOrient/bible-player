import 'dart:ui';

import 'package:bible_player/notifier/music_model.dart';
import 'package:bible_player/notifier/player_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../common/favorites_button.dart';
import '../common/play_mode_button.dart';
import '../entity/music_data.dart';

class PlayController extends StatelessWidget {
  const PlayController({super.key});

  @override
  Widget build(BuildContext context) {
    AudioPlayer player = context.read<PlayerModel>().player;

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withAlpha(0),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    title: const Text(
                      '歌曲',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    centerTitle: true,
                    foregroundColor: const Color(0xFF303133),
                    backgroundColor: Colors.transparent),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            "assets/images/bg6.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Consumer<MusicModel>(builder: (context, musicModel, child) {
                      MusicSection? section = musicModel.getCurrentSection();
                      String title = section != null ? section.name : "";
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 30, right: 30),
                        title: Text(title),
                        subtitle: Text(musicModel.subtitle),
                        trailing: section != null
                            ? FavoritesButton(section)
                            : const SizedBox.shrink(),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 50, left: 24, right: 24, bottom: 0),
                      child: SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 2,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 0,
                          ),
                        ),
                        child: Slider(
                          max: 100,
                          min: 0,
                          divisions: 10,
                          label: "50",
                          value: 50,
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "03:10",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF909399),
                            ),
                          ),
                          Text(
                            "04:29",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF909399),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 70,
                      ),
                      child: Row(
                        children: [
                          PlayModeButton(player),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => player.seekToPrevious(),
                                  child: const Icon(
                                    Icons.skip_previous,
                                    color: Color(0xFF303133),
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                StreamBuilder<PlayerState>(
                                  stream: player.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    final playing = playerState?.playing;
                                    if (playing == true) {
                                      return GestureDetector(
                                        onTap: () => player.pause(),
                                        child: const Icon(
                                          Icons.pause_circle,
                                          color: Colors.red,
                                          size: 70,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () => player.play(),
                                        child: const Icon(
                                          Icons.play_circle,
                                          color: Colors.red,
                                          size: 70,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => player.seekToNext(),
                                  child: const Icon(
                                    Icons.skip_next,
                                    color: Color(0xFF303133),
                                    size: 58,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.queue_music,
                              color: Color(0xFF606266),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
