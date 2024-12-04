enum PlayMode {
  // 随机
  shuffle,
  // 单曲循环
  loopOne,
  // 列表循环
  loopAll,
  // 列表顺序播放
  loopOff,
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

enum PlayListType {
  // 常规
  convention,
  // 喜爱
  favorites,
}
