class MusicSource {
  List<MusicGroup> data;

  MusicSource(this.data);

  // 从 JSON 创建 MusicSource 对象
  factory MusicSource.fromJson(List<dynamic> json) {
    var groups = json.map((itemJson) => MusicGroup.fromJson(itemJson)).toList();
    return MusicSource(groups);
  }

  // 将 MusicSource 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MusicGroup {
  String title;
  String id;
  List<MusicChapter> chapters;

  MusicGroup(this.title, this.id, this.chapters);

  // 从 JSON 创建 MusicGroup 对象
  factory MusicGroup.fromJson(Map<String, dynamic> json) {
    var chapters = (json['chapters'] as List)
        .map((itemJson) => MusicChapter.fromJson(itemJson))
        .toList();
    return MusicGroup(json['title'], json['id'], chapters);
  }

  // 将 MusicGroup 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      "id": id,
      'chapters': chapters.map((item) => item.toJson()).toList(),
    };
  }
}

class MusicChapter {
  String name;
  String id;

  List<MusicSection> sections;

  MusicChapter(this.name, this.id, this.sections);

  // 从 JSON 创建 MusicChapter 对象
  factory MusicChapter.fromJson(Map<String, dynamic> json) {
    var list = (json['sections'] as List)
        .map((itemJson) => MusicSection.fromJson(itemJson))
        .toList();
    return MusicChapter(json['name'], json['id'], list);
  }

  // 将 MusicChapter 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      "id": id,
      'sections': sections.map((item) => item.toJson()).toList(),
    };
  }
}

class MusicSection {
  String name;
  String id;
  String url;
  String subtitle;

  MusicSection(this.name, this.id, this.url, this.subtitle);

  // 从 JSON 创建 MusicSection 对象
  factory MusicSection.fromJson(Map<String, dynamic> json) {
    return MusicSection(
        json['name'], json['id'], json['url'], json['subtitle']);
  }

  // 将 MusicSection 转换为 JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'url': url, 'subtitle': subtitle};
  }
}
