import 'dart:io';
import 'package:bible_player/notifier/favorites_model.dart';
import 'package:bible_player/notifier/music_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as prefix;

import 'package:bible_player/config.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';
import '../entity/play_mode.dart';

class PlayerModel extends GetxController {
  // 播放器实例
  final AudioPlayer player = AudioPlayer();
  // 数据源模块
  late MusicModel musicModel;

  // 当前挂载的播单
  MusicChapter? currentMusicChapter;
  // 当前挂载的播单类型
  PlayListType? get currentMusicChapterType {
    if (currentMusicChapter == null) return null;
    return currentMusicChapter!.id == FavoritesModel.playListId
        ? PlayListType.favorites
        : PlayListType.convention;
  }

  // 当前播放的音乐
  MusicSection? currentMusicSection;

  Stream<PositionData> get positionDataStream =>
      prefix.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  PlayerModel() {
    musicModel = Get.find<MusicModel>();
    _onSectionIndexChange();
  }

  // 监听正在播放的索引变化
  _onSectionIndexChange() {
    player.currentIndexStream.listen((index) {
      print("正在播放的索引变化$index");
      if (index == null) return;
      if (currentMusicChapter == null) return;
      currentMusicSection = currentMusicChapter!.sections[index];
      print("正在播放的音乐${currentMusicSection!.id}");
      update(["currentMusicSection"]);
    });
  }

  // 挂载播单
  _setMusicChapter(MusicChapter musicChapter, {int? initIndex}) async {
    List<LockCachingAudioSource> audioSource = [];
    for (var section in musicChapter.sections) {
      audioSource.add(
        LockCachingAudioSource(
          Uri.parse('${Config.httpBase}/${section.url}'),
          tag: section,
          cacheFile: await _getCacheFilePath(section.name),
        ),
      );
    }
    currentMusicChapter = musicChapter;
    update(["currentMusicChapter"]);

    await player.setAudioSource(
      initialIndex: initIndex,
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: audioSource,
      ),
    );
    await player.setLoopMode(LoopMode.all);
    await player.setShuffleModeEnabled(false);
  }

  // 获取音频缓存地址
  _getCacheFilePath(String fileName) async {
    Directory? downDir = await getDownloadsDirectory();
    if (downDir != null) {
      return File(join(downDir.path, fileName));
    }
  }

  // 检查并且设置播单
  _checkAndSetMusicChapter(MusicSection section) async {
    IdInfo idInfo = IdInfo.fromMusicSectionId(section.id);
    if (idInfo.chapterId != currentMusicChapter?.id) {
      MusicModel musicModel = Get.find();
      MusicChapter chapter = musicModel
          .source.data[idInfo.groupIndex].chapters[idInfo.chapterIndex];
      await _setMusicChapter(chapter, initIndex: idInfo.sectionIndex);
    }
  }

  // 播放
  Future play(MusicSection section) async {
    await _checkAndSetMusicChapter(section);
    if (section.id != currentMusicSection?.id) {
      int sectionIndex = int.parse(section.id.split("_").removeLast());
      await player.seek(Duration.zero, index: sectionIndex);
    }
    if (!player.playing) {
      await player.play();
    }
  }

  // 播放全部
  playAll(MusicChapter musicChapter) async {
    if (musicChapter.id != currentMusicChapter?.id) {
      await _setMusicChapter(musicChapter);
    }
    await player.seek(Duration.zero, index: 0);
    await player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  recoveredCurrentMusicSection(MusicSection currentMusicSection) {
    this.currentMusicSection = currentMusicSection;
    update(["currentMusicSection"]);
  }

  // recoveredCurrentMusicSection必须优先调用
  recoveredCurrentMusicChapter(MusicChapter currentMusicChapter) async {
    if (currentMusicSection == null) return;
    IdInfo info = IdInfo.fromMusicSectionId(currentMusicSection!.id);
    await _setMusicChapter(currentMusicChapter, initIndex: info.sectionIndex);
    update(["currentMusicChapter"]);
  }
}
