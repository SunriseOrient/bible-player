import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            Text("qweqeq"),
          ],
        ),
      ),
    );
  }
}
