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
    return const Text("data");
  }
}

// 播单标题
class PlaylistTitle extends StatelessWidget {
  const PlaylistTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "新约",
      style: TextStyle(fontSize: 40, color: Colors.white, letterSpacing: 5),
    );
  }
}

// 更多 按钮
class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      tooltip: '更多',
      color: Colors.white,
      onPressed: () {},
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
          return ListTile(title: Text('item$index'));
        });
  }
}
