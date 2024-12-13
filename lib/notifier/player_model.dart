import 'dart:io';
import 'package:bible_player/notifier/favorites_model.dart';
import 'package:bible_player/notifier/music_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bible_player/config.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';
import '../entity/play_mode.dart';

class PlayerModel extends GetxController {
  // 播放器实例
  AudioPlayer player = AudioPlayer();
  // 数据源模块
  MusicModel musicModel = Get.find<MusicModel>();

  // 加载的清单类型
  PlayListType? loadListType;
  // 播放的音频
  MusicSection? playSection;

  // 已加载的清单ID 喜爱列表的ID为：-1_-1
  String? loadedListId;
  // 已加载的音频列表
  List<LockCachingAudioSource>? loadedList;

  @override
  onInit() {
    super.onInit();
    _onSectionIndexChange();
  }

  // 监听正在播放的索引变化
  _onSectionIndexChange() {
    player.currentIndexStream.listen((index) {
      print("监听到音频索引变化：$index");
      if (index == null) return;
      if (loadedList == null) return;
      playSection = loadedList![index].tag;
      update(["playSection"]);
    });
  }

  // 设置音频列表
  _setMusicList(
    List<MusicSection> sections,
    String loadedListId,
    PlayListType loadListType,
  ) async {
    List<LockCachingAudioSource> audioSource = [];
    for (var section in sections) {
      audioSource.add(
        LockCachingAudioSource(
          Uri.parse('${Config.httpBase}/${section.url}'),
          tag: section,
          cacheFile: await _getCacheFilePath(section.name),
        ),
      );
    }

    loadedList = audioSource;
    this.loadedListId = loadedListId;
    this.loadListType = loadListType;

    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: audioSource,
      ),
    );
    await player.setLoopMode(LoopMode.all);
    await player.setShuffleModeEnabled(false);
  }

  // 获取音频mp3缓存地址
  _getCacheFilePath(String fileName) async {
    Directory? downDir = await getDownloadsDirectory();
    if (downDir != null) {
      return File(join(downDir.path, fileName));
    }
  }

  // 检查并加载列表数据
  _checkAndLoadMusicList(MusicSection section, PlayListType type) async {
    if (type == PlayListType.convention) {
      final indexMap = _getListId(section);
      String loadedListId = indexMap["id"];
      if (loadedListId == this.loadedListId) return;
      MusicGroup group = musicModel.source.data[indexMap["groupIndex"]];
      await _setMusicList(
        group.chapters[indexMap["chapterIndex"]].sections,
        loadedListId,
        type,
      );
    }
    if (type == PlayListType.favorites) {
      String loadedListId = "-1_-1";
      if (loadedListId == this.loadedListId) return;
      await _setMusicList(
        Get.find<FavoritesModel>().sections,
        loadedListId,
        type,
      );
    }
  }

  // 获取列表ID
  _getListId(MusicSection section) {
    List<int> indexs =
        section.id.split("_").map((item) => int.parse(item)).toList();
    int sectionIndex = indexs.removeLast();
    return {
      "sectionIndex": sectionIndex,
      "id": indexs.join("_"),
      "groupIndex": indexs[0],
      "chapterIndex": indexs[1],
    };
  }

  // 播放
  Future play(MusicSection section, PlayListType type, {bool? noPlay}) async {
    await _checkAndLoadMusicList(section, type);
    if (type != loadListType || playSection?.id != section.id) {
      int sectionIndex = int.parse(section.id.split("_").removeLast());
      await player.seek(Duration.zero, index: sectionIndex);
    }
    if (noPlay == true) return;
    await player.play();
  }

  // 播放全部
  playAll(PlayListType type) async {
    MusicSection? fristSection;

    if (type == PlayListType.convention) {
      MusicModel musicModel = Get.find<MusicModel>();
      MusicChapter? musicChapter = musicModel.getCurrentChapter();
      if (musicChapter == null) return;
      if (musicChapter.sections.isEmpty) return;
      fristSection = musicChapter.sections[0];
    }

    if (type == PlayListType.favorites) {
      FavoritesModel favoritesModel = Get.find<FavoritesModel>();
      _setMusicList(favoritesModel.sections, "-1_-1", PlayListType.favorites);
      fristSection = favoritesModel.sections[0];
    }

    if (fristSection == null) return;
    await play(fristSection, type);
    loadListType = type;
  }

  // 设置正在播放的音频数据
  setPlaySection(MusicSection section) {
    playSection = section;
    update(["playSection"]);
  }

  // 设置列表的模式
  setLoadListType(PlayListType type) {
    loadListType = type;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
