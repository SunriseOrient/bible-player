class UpdateInfo {
  bool hasUpdate;
  bool isBetaUser;
  String? upgradeMode;
  LatestVersion? latestVersion;

  UpdateInfo(
      this.hasUpdate, this.isBetaUser, this.upgradeMode, this.latestVersion);

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      json['hasUpdate'],
      json['isBetaUser'],
      json['upgradeMode'],
      json['latestVersion'] != null
          ? LatestVersion.fromJson(json['latestVersion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasUpdate': hasUpdate,
      'isBetaUser': isBetaUser,
      'upgradeMode': upgradeMode,
      'latestVersion': latestVersion?.toJson(),
    };
  }
}

class LatestVersion {
  String version;
  String changelog;
  String downloadUrl;
  String status;
  String createdAt;

  LatestVersion(this.version, this.changelog, this.downloadUrl, this.status,
      this.createdAt);

  factory LatestVersion.fromJson(Map<String, dynamic> json) {
    return LatestVersion(
      json['version'],
      json['changelog'],
      json['downloadUrl'],
      json['status'],
      json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'changelog': changelog,
      'downloadUrl': downloadUrl,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
