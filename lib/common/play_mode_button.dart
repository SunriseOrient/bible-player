import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayModeButton extends StatefulWidget {
  AudioPlayer player;
  PlayModeButton(this.player);

  @override
  State<PlayModeButton> createState() => _PlayModeButtonState();
}

class _PlayModeButtonState extends State<PlayModeButton> {
  int playModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
