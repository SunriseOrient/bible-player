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
  MusicModel musicModel = Get.find<MusicModel>();

  String? loadedListId;
  List<LockCachingAudioSource>? loadedList;
  MusicSection? currentSection;

  @override
  onInit() {
    super.onInit();
    _onSectionIndexChange();
  }

  _onSectionIndexChange() {
    player.currentIndexStream.listen((index) {
      print("索引变化$index");
      if (index == null) return;
      if (loadedList == null) return;
      currentSection = loadedList![index].tag;
      print("当前播放$currentSection");
      update(["currentSection"]);
    });
  }

  _setMusicList(String listId) async {
    List<int> idArray =
        listId.split("_").map((item) => int.parse(item)).toList();
    if (idArray[0] > musicModel.source.data.length) return;
    MusicGroup group = musicModel.source.data[idArray[0]];
    List<MusicSection> sections = group.chapters[idArray[1]].sections;

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
    loadedList = audioSource;
  }

  _getCacheFilePath(String fileName) async {
    Directory? downDir = await getDownloadsDirectory();
    if (downDir != null) {
      return File(join(downDir.path, fileName));
    }
  }

  play(MusicSection section, {bool? noPlay}) async {
    List<String> idArray = section.id.split("_");
    String sectionIndex = idArray.removeLast();
    String listId = idArray.join("_");
    if (listId != loadedListId) {
      await _setMusicList(listId);
    }
    await player.seek(Duration.zero, index: int.parse(sectionIndex));
    if (noPlay != true) {
      await player.play();
    }
  }

  playAll() {}

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  recoveredState(MusicSection section) {
    currentSection = section;
    update(["currentSection"]);
  }
}
