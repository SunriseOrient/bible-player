import 'package:flutter/material.dart';

class PlayPanel extends StatefulWidget {
  @override
  State<PlayPanel> createState() => _PlayPanelState();
}

class _PlayPanelState extends State<PlayPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        title: Text("data"),
        subtitle: Text("data"),
      ),
    );
  }
}
