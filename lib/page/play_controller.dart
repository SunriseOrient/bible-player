import 'dart:ui';

import 'package:bible_player/config.dart';
import 'package:bible_player/notifier/player_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as prefix;

import '../common/favorites_button.dart';
import '../common/play_list.dart';
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
    player = Get.find<PlayerModel>().player;
  }

  Stream<PositionData> get _positionDataStream =>
      prefix.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
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
                  backgroundColor: Colors.transparent,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 60,
                        right: 60,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: GetBuilder<PlayerModel>(
                            id: "currentMusicChapter",
                            builder: (playerModel) {
                              if (playerModel.currentMusicChapter == null) {
                                return const SizedBox();
                              }
                              String musicChapterId =
                                  playerModel.currentMusicChapter!.id;
                              return Image.network(
                                "${Config.httpBase}/封面/$musicChapterId.png",
                                fit: BoxFit.cover,
                              );
                            }),
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
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 30, right: 30),
                          title: Text(section.name),
                          subtitle: Text(section.subtitle),
                          trailing: FavoritesButton(section),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 24,
                        right: 24,
                        bottom: 0,
                      ),
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
                            onTap: () {
                              showCurrentPlayList(context);
                            },
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

showCurrentPlayList(BuildContext context) {
  PlayerModel playerModel = Get.find<PlayerModel>();
  List<MusicSection> sections = playerModel.currentMusicChapter?.sections ?? [];
  double screenHeight = MediaQuery.of(context).size.height;
  return showModalBottomSheet(
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: screenHeight * 3 / 4),
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              child: Container(
                width: 50,
                height: 5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xFFF4F4F5),
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 1,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: const TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    dividerColor: Color(0xFFF4F4F5),
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(
                        text: "当前播放",
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    PlayList(sections, listTileTap: (section) {
                      playerModel.play(section);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
