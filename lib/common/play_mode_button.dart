import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/play_mode.dart';

class PlayModeButton extends StatefulWidget {
  final AudioPlayer player;
  const PlayModeButton(this.player, {super.key});

  @override
  State<PlayModeButton> createState() => _PlayModeButtonState();
}

class _PlayModeButtonState extends State<PlayModeButton> {
  int playModeIndex = 0;

  final modes = [
    PlayMode.loopAll,
    PlayMode.loopOne,
    PlayMode.loopOff,
    PlayMode.shuffle
  ];

  _nextMode() async {
    int playModeIndexTmp = playModeIndex + 1;
    if (playModeIndexTmp == modes.length) {
      playModeIndexTmp = 0;
    }
    PlayMode mode = modes[playModeIndexTmp];
    setState(() {
      playModeIndex = playModeIndexTmp;
    });
    if (mode == PlayMode.loopAll) {
      await widget.player.setShuffleModeEnabled(false);
      await widget.player.setLoopMode(LoopMode.all);
    }
    if (mode == PlayMode.loopOne) {
      await widget.player.setLoopMode(LoopMode.one);
    }
    if (mode == PlayMode.loopOff) {
      await widget.player.setLoopMode(LoopMode.off);
    }
    if (mode == PlayMode.shuffle) {
      await widget.player.setShuffleModeEnabled(true);
      await widget.player.setLoopMode(LoopMode.all);
    }
  }

  IconData _getIcon() {
    PlayMode mode = modes[playModeIndex];
    if (mode == PlayMode.loopAll) {
      return Icons.repeat;
    } else if (mode == PlayMode.loopOne) {
      return Icons.repeat_one;
    } else if (mode == PlayMode.loopOff) {
      return Icons.format_list_numbered;
    } else if (mode == PlayMode.shuffle) {
      return Icons.shuffle;
    } else {
      return Icons.expand;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nextMode();
      },
      child: Icon(
        _getIcon(),
        color: const Color(0xFF606266),
        size: 28,
      ),
    );
  }
}
