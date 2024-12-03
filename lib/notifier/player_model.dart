import 'dart:io';
import 'package:bible_player/notifier/music_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bible_player/config.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';

class PlayerModel extends GetxController {
  AudioPlayer player = AudioPlayer();
  late MusicSource _musicSource;

  String? loadedListId;

  @override
  onInit() {
    super.onInit();
    _musicSource = Get.find<MusicModel>().source;
  }

  _setMusicList(String listId) async {
    List<String> idArray = listId.split("_");
    MusicGroup group = _musicSource.data[int.parse(idArray[0])];
    List<MusicSection> sections =
        group.chapters[int.parse(idArray[1])].sections;

    List<LockCachingAudioSource> audioSource = [];
    for (var section in sections) {
      audioSource.add(LockCachingAudioSource(
          Uri.parse('${Config.httpBase}/${section.mp3}'),
          tag: section,
          cacheFile: await _getCacheFilePath(section.name)));
    }

    await player.setAudioSource(ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: audioSource));
    await player.setLoopMode(LoopMode.all);
    await player.setShuffleModeEnabled(false);
    loadedListId = listId;
  }

  _getCacheFilePath(String fileName) async {
    Directory? downDir = await getDownloadsDirectory();
    if (downDir != null) {
      return File(join(downDir.path, fileName));
    }
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
