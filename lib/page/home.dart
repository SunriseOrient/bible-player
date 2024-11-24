import 'dart:ui';

import 'package:flutter/material.dart';

import '../entity/music_data.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MusicSource musicSource = MusicSource([]);

  @override
  void initState() {
    super.initState();
    _loadMusicSource();
  }

  _loadMusicSource() async {
    MusicSource source = await getMusicSource();
    setState(() {
      musicSource = source;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 40),
              child: Text(
                "Hello",
                style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: musicSource.data.length,
                  itemBuilder: (context, index) {
                    return MusicGroupBox(musicSource.data[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MusicGroupBox extends StatelessWidget {
  late MusicGroup musicGroup;

  MusicGroupBox(this.musicGroup);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              musicGroup.title,
              style: TextStyle(fontSize: 18),
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
                  child: MusicChapterBox(musicGroup.chapters[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MusicChapterBox extends StatelessWidget {
  MusicChapter musicChapter;

  MusicChapterBox(this.musicChapter);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/music_list');
        },
        child: Stack(
          children: [
            Container(
              width: 180,
              color: Color(0xFFF5F5F5),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 50,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
