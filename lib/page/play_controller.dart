import 'dart:ui';

import 'package:bible_player/notifier/music_model.dart';
import 'package:bible_player/notifier/player_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../common/favorites_button.dart';
import '../common/play_mode_button.dart';
import '../common/seek_bar.dart';
import '../entity/music_data.dart';
import '../entity/play_mode.dart';

class PlayController extends StatefulWidget {
  const PlayController({super.key});

  @override
  State<PlayController> createState() => _PlayControllerState();
}

class _PlayControllerState extends State<PlayController> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = context.read<PlayerModel>().player;
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
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
                    StreamBuilder(
                      stream: player.currentIndexStream,
                      builder: (context, snapshot) {
                        int currentIndex = snapshot.data ?? 0;
                        List<IndexedAudioSource>? sequence = player.sequence;
                        if (sequence == null) return const ListTile();
                        MusicSection section = sequence[currentIndex].tag;
                        String subtitle = context
                            .read<MusicModel>()
                            .getSubtitleBySectionId(section.id);
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 30, right: 30),
                          title: Text(section.name),
                          subtitle: Text(subtitle),
                          trailing: FavoritesButton(section),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, left: 24, right: 24, bottom: 0),
                      child: StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return SeekBar(
                            duration: positionData?.duration ?? Duration.zero,
                            position: positionData?.position ?? Duration.zero,
                            bufferedPosition:
                                positionData?.bufferedPosition ?? Duration.zero,
                            onChangeEnd: player.seek,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
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
