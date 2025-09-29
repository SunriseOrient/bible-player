class SettingData {
  bool isOfflineMode;

  SettingData({this.isOfflineMode = false});

  Map<String, dynamic> toJson() {
    return {
      'isOfflineMode': isOfflineMode,
    };
  }

  factory SettingData.fromJson(Map<String, dynamic> json) {
    return SettingData(
      isOfflineMode: json['isOfflineMode'] ?? false,
    );
  }
}
