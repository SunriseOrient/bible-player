import 'package:bible_player/config.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';

class PlayerModel extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();
  late MusicSource _musicSource;

  String? loadedListId;

  setMusicSource(MusicSource musicSource) {
    _musicSource = musicSource;
  }

  _setMusicList(String listId) async {
    List<String> idArray = listId.split("_");
    MusicGroup group = _musicSource.data[int.parse(idArray[0])];
    List<MusicSection> sections =
        group.chapters[int.parse(idArray[1])].sections;

    List<AudioSource> audioSource = [];
    for (var section in sections) {
      audioSource
          .add(AudioSource.uri(Uri.parse('${Config.httpBase}/${section.mp3}')));
    }

    await player
        .setAudioSource(ConcatenatingAudioSource(children: audioSource));
    loadedListId = listId;
  }

  play(MusicSection section) async {
    List<String> idArray = section.id.split("_");
    String sectionIndex = idArray.removeLast();
    String listId = idArray.join("_");
    if (listId != loadedListId) {
      await _setMusicList(listId);
    }
    await player.seek(Duration.zero, index: int.parse(sectionIndex));
    await player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
