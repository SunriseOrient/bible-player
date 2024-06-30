import 'dart:ui';

import 'package:flutter/material.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("播单列表"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: ["新约", "旧约"].map((title) {
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF535CE9),
                      Color(0xFFB582F8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: SizedBox(),
                    ),
                    Align(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 50,
                          letterSpacing: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
