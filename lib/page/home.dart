import 'package:bible_player/notifier/music_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/music_data.dart';

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
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Hello',
                    style: TextStyle(fontSize: 58),
                  ),
                ),
                collapseMode: CollapseMode.pin,
                expandedTitleScale: 1.5,
              ),
              automaticallyImplyLeading: false,
              pinned: true,
              collapsedHeight: 160,
              expandedHeight: 200,
            ),
            GetBuilder<MusicModel>(
              id: "source",
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
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: musicGroup.chapters.length,
            itemBuilder: (context, index) {
              double paddingRight =
                  index == musicGroup.chapters.length - 1 ? 20 : 10;
              double paddingLeft = index == 0 ? 20 : 0;
              return Padding(
                padding:
                    EdgeInsets.only(right: paddingRight, left: paddingLeft),
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
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Get.find<MusicModel>().updateIndex(
            groupIndex: groupIndex,
            chapterIndex: chapterIndex,
          );
          Navigator.pushNamed(context, '/music_list');
        },
        child: Stack(
          children: [
            Container(
              width: 180,
              color: const Color(0xFFF5F5F5),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 50,
              child: Center(
                child: Text(
                  musicChapter.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
