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

class IdInfo {
  String groupId;
  String chapterId;
  String sectionId;
  int groupIndex;
  int chapterIndex;
  int sectionIndex;

  IdInfo({
    required this.groupId,
    required this.chapterId,
    required this.sectionId,
    required this.groupIndex,
    required this.chapterIndex,
    required this.sectionIndex,
  });

  factory IdInfo.fromMusicSectionId(String id) {
    List<int> ids = id.split("_").map((item) => int.parse(item)).toList();
    return IdInfo(
      groupId: ids[0].toString(),
      chapterId: [ids[0], ids[1]].join("_"),
      sectionId: id,
      groupIndex: ids[0],
      chapterIndex: ids[1],
      sectionIndex: ids[2],
    );
  }
}
