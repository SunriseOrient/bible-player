import 'dart:ui';

import 'package:flutter/material.dart';

class PlayController extends StatelessWidget {
  const PlayController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withAlpha(0),
            ),
          ),
          const SafeArea(
            child: Column(
              children: [Text("data")],
            ),
          ),
        ],
      ),
    );
  }
}
