import 'package:bible_player/notifier/music_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/chapter_icon.dart';
import '../entity/music_data.dart';
import '../notifier/one_sentence_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                const SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    title: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style:
                                TextStyle(fontSize: 36, color: Color(0xff1F2937)),
                          ),
                          Text(
                            '与主同行，聆听生命真理',
                            style:
                                TextStyle(fontSize: 14, color: Color(0xff6B7280)),
                          )
                        ],
                      ),
                    ),
                    collapseMode: CollapseMode.pin,
                    expandedTitleScale: 1.5,
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  collapsedHeight: 145,
                  expandedHeight: 170,
                ),
                GetBuilder<MusicModel>(
                  builder: (musicModel) {
                    MusicSource source = musicModel.source;
                    return SliverList.builder(
                      itemCount: source.data.length,
                      itemBuilder: (context, index) {
                        return MusicGroupBox(
                          source.data[index],
                          groupIndex: index,
                        );
                      },
                    );
                  },
                ),
                GetBuilder<OneSentenceModel>(
                  builder: (oneSentenceModel) {
                    Duration duration = const Duration(milliseconds: 300);
                    bool isShow = oneSentenceModel.text != "";
                    return SliverToBoxAdapter(
                      child: AnimatedSize(
                        duration: duration,
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: AnimatedOpacity(
                          opacity: isShow ? 1 : 0,
                          duration: duration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: isShow ? null : 0,
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                color: Color(0xFFF5F5F5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "“",
                                          style: TextStyle(
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "每日金句",
                                          style: TextStyle(
                                            color: Color(0xFF6B7280),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      oneSentenceModel.text,
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${oneSentenceModel.book} ${oneSentenceModel.chapter}:${oneSentenceModel.verse}',
                                          style: const TextStyle(
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: const Icon(
                  Icons.more_vert,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MusicGroupBox extends StatelessWidget {
  final MusicGroup musicGroup;
  final int groupIndex;

  const MusicGroupBox(this.musicGroup, {super.key, required this.groupIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            musicGroup.title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          height: 156,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: musicGroup.chapters.length,
            itemBuilder: (context, index) {
              double paddingLeft = index == 0 ? 20 : 0;
              return Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: paddingLeft,
                  top: 10,
                  bottom: 10,
                ),
                child: MusicChapterBox(
                  musicGroup.chapters[index],
                  groupIndex: groupIndex,
                  chapterIndex: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MusicChapterBox extends StatelessWidget {
  final MusicChapter musicChapter;
  final int groupIndex;
  final int chapterIndex;

  const MusicChapterBox(this.musicChapter,
      {super.key, required this.groupIndex, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/music_list', arguments: {
          "groupIndex": groupIndex,
          "chapterIndex": chapterIndex,
        });
      },
      child: Container(
        width: 163,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: Color(0xFFF5F5F5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  musicChapter.icon == ""
                      ? Icons.album
                      : chapterIcons[musicChapter.icon],
                  size: 38,
                ),
              ),
              Text(
                musicChapter.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                musicChapter.desc,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
