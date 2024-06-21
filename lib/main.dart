import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 300,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFF535CE9), Color(0xFFB582F8)])),
        ),
        Flex(
          direction: Axis.vertical,
          children: [
            AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: '更多',
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
              backgroundColor: Colors.transparent,
            ),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 30),
              child: const Text(
                "新约",
                style: TextStyle(
                    fontSize: 40, color: Colors.white, letterSpacing: 5),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_circle,
                                color: Colors.red,
                                size: 28,
                              ),
                              Container(
                                width: 5,
                              ),
                              const Text(
                                "全部播放",
                              )
                            ],
                          )),
                      Container(
                        color: Colors.red,
                      )
                    ],
                  ),
                )),
            Expanded(flex: 0, child: Text("data"))
          ],
        )
      ],
    ));
  }
}
