import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/delay_tween.dart';

class PlayingIcon extends StatefulWidget {
  final Stream<bool> playingStream;
  const PlayingIcon(this.playingStream, {super.key});

  @override
  State<PlayingIcon> createState() => _PlayingIconState();
}

class _PlayingIconState extends State<PlayingIcon>
    with TickerProviderStateMixin {
  double width = 24;
  double height = 20;
  int itemNumber = 3;
  int duration = 800;

  late double itemWidth = width / (itemNumber * 2);
  late AnimationController animationController;
  late StreamSubscription<bool> onPlayingStream;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    onPlayingStream = widget.playingStream.listen((isPlaying) {
      setState(() {
        if (isPlaying) {
          animationController.repeat();
        } else {
          animationController.stop();
        }
      });
    });
  }

  _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    onPlayingStream.cancel();
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
              animation: animationController,
              builder: (_, child) {
                return Container(
                  width: itemWidth,
                  height: DelayTween(begin: 0.0, end: height, delay: index * .2)
                      .animate(animationController)
                      .value,
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
