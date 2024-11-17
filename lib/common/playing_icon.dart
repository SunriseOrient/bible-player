import 'dart:async';

import 'package:flutter/material.dart';

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
  late List<Timer> timers = [];

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

      Timer timer = Timer(
          Duration(milliseconds: ((i + 1) / itemNumber * duration).toInt()),
          () => animationController.repeat(reverse: true));
      timers.add(timer);
    }
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer.cancel();
    }
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
