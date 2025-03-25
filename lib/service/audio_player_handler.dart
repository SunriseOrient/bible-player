import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../notifier/player_model.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  // static final _item = MediaItem(
  //   id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
  //   album: "aaa",
  //   title: "bbb",
  //   artist: "artistScience Friday and WNYC Studios",
  //   duration: Duration(milliseconds: 5739820),
  // );

  late PlayerModel playerModel;
  late AudioPlayerHandler audioHandler;

  AudioPlayerHandler() {
    playerModel = Get.find<PlayerModel>();
  }

  init() async {
    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.bible_player.channel.audio',
        androidNotificationChannelName: 'Bible Player',
        androidNotificationOngoing: true,
      ),
    );

    playerModel.addListenerId("currentMusicSection", () {
      mediaItem.add(MediaItem(
        id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artist: "Science Friday and WNYC Studios",
        duration: const Duration(milliseconds: 5739820),
      ));
    });

    playerModel.player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState);
  }

  @override
  Future<void> play() => playerModel.player.play();

  @override
  Future<void> pause() => playerModel.player.pause();

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
