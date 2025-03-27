import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../entity/music_data.dart';
import '../notifier/player_model.dart';

/// 后台播放服务 控制面板播放控制卡片
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  late PlayerModel playerModel;
  late AudioPlayerHandler audioHandler;

  AudioPlayerHandler() {
    playerModel = Get.find<PlayerModel>();

    playerModel.player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState);

    playerModel.positionDataStream.listen((positionData) {
      MediaItem? mediaItemValue = mediaItem.value;
      if (mediaItemValue == null) return;
      mediaItem.add(mediaItemValue.copyWith(duration: positionData.duration));
    });

    playerModel.addListenerId("currentMusicSection", () {
      MusicSection? currentMusicSection = playerModel.currentMusicSection;
      MusicChapter? currentMusicChapter = playerModel.currentMusicChapter;
      if (currentMusicSection == null) return;
      if (currentMusicChapter == null) return;
      mediaItem.add(MediaItem(
        id: currentMusicSection.id,
        album: currentMusicChapter.name,
        title: currentMusicSection.name,
        artist: currentMusicSection.subtitle,
      ));
    });
  }

  @override
  Future<void> play() => playerModel.player.play();

  @override
  Future<void> pause() => playerModel.player.pause();

  @override
  Future<void> skipToNext() => playerModel.player.seekToNext();

  @override
  Future<void> skipToPrevious() => playerModel.player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => playerModel.player.seek(position);

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playerModel.player.playing)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.play,
        MediaAction.pause,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[playerModel.player.processingState]!,
      playing: playerModel.player.playing,
      updatePosition: playerModel.player.position,
      bufferedPosition: playerModel.player.bufferedPosition,
      speed: playerModel.player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
