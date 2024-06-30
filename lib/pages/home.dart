import 'dart:async';

import 'package:bible_player/pages/playlist.dart';
import 'package:bible_player/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const TopBg(),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                actions: const [
                  MoreButton(),
                ],
              ),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30),
                child: const PlaylistTitle(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [MusicListHead(), Expanded(child: MusicList())],
                  ),
                ),
              ),
              const SizedBox(child: Playcontroller())
            ],
          )
        ],
      ),
    );
  }
}

// 播放控制器
class Playcontroller extends StatelessWidget {
  const Playcontroller({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey[200], //背景颜色
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("12:03"),
              Text("12:03"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.grading,
                  size: 24,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.skip_previous,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.play_circle,
                      size: 60,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.skip_next,
                      size: 40,
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 播单标题
class PlaylistTitle extends StatefulWidget {
  const PlaylistTitle({super.key});

  @override
  State<StatefulWidget> createState() {
    return PlaylistTitleState();
  }
}

class PlaylistTitleState extends State<PlaylistTitle> {
  _goPlaylistPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PlaylistPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goPlaylistPage(context),
      child: const Text(
        "新约",
        style: TextStyle(fontSize: 40, color: Colors.white, letterSpacing: 5),
      ),
    );
  }
}

// 更多 按钮
class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

  _goSettingsPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      tooltip: '更多',
      color: Colors.white,
      onPressed: () => _goSettingsPage(context),
    );
  }
}

// 头部背景
class TopBg extends StatelessWidget {
  const TopBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF535CE9), Color(0xFFB582F8)])),
    );
  }
}

// 音乐列表头部
class MusicListHead extends StatelessWidget {
  const MusicListHead({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.play_circle,
            color: Colors.red,
            size: 28,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "全部播放",
          )
        ],
      ),
    );
  }
}

// 音乐列表
class MusicList extends StatelessWidget {
  const MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return MusicListItem(
            index: index,
          );
        });
  }
}

// 音乐列表 音乐实体
class MusicListItem extends StatelessWidget {
  const MusicListItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('item$index'),
      // leading: PlayingIcon(
      //   width: 20,
      //   height: 20,
      //   color: Colors.red,
      // ),
      // leading: Container(
      //   width: 20,
      //   height: 20,
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Text(
      //       index.toString(),
      //       style: TextStyle(
      //         color: Color(0xFFC0C4CC),
      //         fontSize: 14,
      //       ),
      //     ),
      //   ),
      // ),
      leading: Icon(
        Icons.pause,
        color: Color(0xFFC0C4CC),
        size: 24,
      ),
    );
  }
}

// 正在播放图标
class PlayingIcon extends StatelessWidget {
  const PlayingIcon({
    super.key,
    this.width = 20,
    this.height = 20,
    this.color = Colors.red,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [0.15, 0.85, 0.55].map((delay) {
          return PlayingIconItem(
            width: width,
            height: height,
            color: color,
            delay: delay,
            duration: Duration(milliseconds: 600),
          );
        }).toList(),
      ),
    );
  }
}

// 正在播放图标内动画元素
class PlayingIconItem extends StatefulWidget {
  const PlayingIconItem({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.delay,
    required this.duration,
  });

  final double width;
  final double height;
  final Color color;

  final double delay;
  final Duration duration;

  @override
  State<StatefulWidget> createState() {
    return _PlayingIconItemState();
  }
}

class _PlayingIconItemState extends State<PlayingIconItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animation =
        Tween(begin: 2.0, end: widget.height).animate(animationController);
    timer = Timer(
        Duration(
            milliseconds:
                (widget.duration.inMilliseconds * widget.delay).toInt()),
        () => animationController.repeat(reverse: true));
  }

  @override
  void dispose() {
    timer.cancel();
    animationController
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: widget.width / 7,
          height: animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(widget.width / 12),
              topLeft: Radius.circular(widget.width / 14),
            ),
          ),
        );
      },
    );
  }
}
