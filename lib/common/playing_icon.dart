import 'dart:async';

import 'package:bible_player/notifier/player_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../entity/music_data.dart';

class PlayListIcon extends StatelessWidget {
  final MusicSection section;
  final PlayerModel playerModel = Get.find<PlayerModel>();

  PlayListIcon(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: playerModel.player.playingStream,
        builder: (context, snapshot) {
          bool? index = snapshot.data;
          if (index != true) {
            return const Icon(Icons.play_circle);
          }
          return LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.red, size: 24);
        });
  }
}

class PlayingIcon extends StatefulWidget {
  const PlayingIcon({super.key});

  @override
  State<PlayingIcon> createState() => _PlayingIconState();
}

class _PlayingIconState extends State<PlayingIcon>
    with TickerProviderStateMixin {
  double width = 24;
  double height = 20;
  int itemNumber = 3;
  int duration = 600;

  late double itemWidth = width / (itemNumber * 2);
  late List<Animation> tweens = [];
  late List<AnimationController> animationControllers = [];

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  _initAnimationController() {
    for (int i = 0; i < itemNumber; i++) {
      AnimationController animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: duration),
      );
      animationControllers.add(animationController);
      tweens.add(
        Tween(begin: 0.0, end: height)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(animationController),
      );
      Future.delayed(
          Duration(milliseconds: ((i + 1) / itemNumber * duration).toInt()),
          () {
        animationController.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller.stop();
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          itemNumber,
          (index) {
            return AnimatedBuilder(
              animation: tweens[index],
              builder: (_, child) {
                return Container(
                  width: itemWidth,
                  height: tweens[index].value,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(itemWidth * 0.5),
                      topRight: Radius.circular(itemWidth * 0.5),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
